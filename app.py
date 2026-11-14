import re, sqlite3, time
from pathlib import Path
import pandas as pd
import streamlit as st

st.set_page_config(page_title="Olist SQL", layout="wide")

# Finds the .sql file wherever it is in the repo, whatever it is named
_here = Path(__file__).parent
_sql_files = sorted(_here.rglob("*.sql"))
if not _sql_files:
    st.error("No .sql file found in the repository. Upload your SQL dump next to app.py.")
    st.stop()
SQL_FILE = _sql_files[0]


@st.cache_resource
def get_db():
    sql = SQL_FILE.read_text(encoding="utf-8")
    sql = re.sub(r"(?im)^\s*(CREATE DATABASE|USE)\b[^;]*;", "", sql).replace("`", '"')
    con = sqlite3.connect(":memory:", check_same_thread=False)
    con.executescript(sql)
    return con


con = get_db()
tables = [r[0] for r in con.execute("SELECT name FROM sqlite_master WHERE type='table'")]

with st.sidebar:
    st.header("Tables")
    for t in tables:
        n = con.execute(f'SELECT COUNT(*) FROM "{t}"').fetchone()[0]
        with st.expander(f"{t} ({n} rows)"):
            for c in con.execute(f'PRAGMA table_info("{t}")'):
                st.text(f"{c[1]}  {c[2]}")

st.title("Olist SQL")
st.text_area(
    "Questions (paste or type here)",
    height=150,
    placeholder="Paste your questions here...",
    key="questions",
)
query = st.text_area(
    "SQL query",
    height=180,
    value="SELECT order_status, COUNT(*) AS items\nFROM olist_master\nGROUP BY order_status;",
)

if st.button("Run", type="primary"):
    if not re.match(r"^\s*(SELECT|WITH|PRAGMA|EXPLAIN)\b", query, re.I):
        st.error("Only read queries (SELECT / WITH) are allowed.")
    else:
        try:
            t0 = time.perf_counter()
            df = pd.read_sql_query(query, con)
            st.caption(f"{len(df)} rows · {(time.perf_counter() - t0) * 1000:.1f} ms")
            st.dataframe(df, width="stretch")
            st.download_button("Download CSV", df.to_csv(index=False), "results.csv", "text/csv")
        except Exception as e:
            st.error(str(e))
