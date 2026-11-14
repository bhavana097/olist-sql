import math, re, sqlite3, time
from pathlib import Path
import pandas as pd
import streamlit as st

st.set_page_config(page_title="SQL Practice", layout="wide")

# ---- find database dump(s): any .sql file in the repo that contains CREATE TABLE ----
_here = Path(__file__).parent
dumps = [p for p in sorted(_here.rglob("*.sql"))
         if re.search(r"create\s+table", p.read_text(encoding="utf-8", errors="ignore"), re.I)]
if not dumps:
    st.error("No database dump found. Upload a .sql file containing CREATE TABLE / INSERT statements next to app.py.")
    st.stop()


def split_statements(sql):
    out, buf = [], ""
    for line in sql.splitlines(keepends=True):
        buf += line
        if sqlite3.complete_statement(buf):
            out.append(buf.strip())
            buf = ""
    if buf.strip():
        out.append(buf.strip())
    return out


def strip_comments(s):
    s = re.sub(r"/\*.*?(\*/|$)", "", s, flags=re.S)
    return re.sub(r"--[^\n]*", "", s).strip()


@st.cache_resource
def get_db(path):
    sql = Path(path).read_text(encoding="utf-8", errors="replace")
    sql = re.sub(r"(?im)^\s*(CREATE DATABASE|DROP DATABASE|USE|SET|LOCK TABLES|UNLOCK TABLES)\b[^;]*;", "", sql)
    sql = sql.replace("`", '"')
    sql = re.sub(r"\)\s*(ENGINE|DEFAULT CHARSET|COLLATE)[^;]*;", ");", sql, flags=re.I)
    sql = re.sub(r"\b(AUTO_INCREMENT|UNSIGNED)\b", "", sql, flags=re.I)
    sql = re.sub(r"(?im)^\s*(UNIQUE\s+|FULLTEXT\s+)?KEY\s+[^\n(]*\([^)]*\)\s*,?[ \t]*\n", "", sql)  # MySQL index lines
    sql = re.sub(r",(\s*\n\s*\))", r"\1", sql)  # trailing comma before )
    con = sqlite3.connect(":memory:", check_same_thread=False)
    con.create_function("FLOOR", 1, lambda x: None if x is None else math.floor(x))
    con.create_function("CEIL", 1, lambda x: None if x is None else math.ceil(x))
    con.create_function("CEILING", 1, lambda x: None if x is None else math.ceil(x))
    errors = []
    for i, st_ in enumerate(split_statements(sql), 1):
        try:
            con.execute(st_)
        except sqlite3.Error as e:
            errors.append(f"Statement {i}: {e}")
    con.commit()
    return con, errors


with st.sidebar:
    dump = dumps[0]
    if len(dumps) > 1:
        dump = st.selectbox("Database", dumps, format_func=lambda p: p.name)
    con, load_errors = get_db(str(dump))
    st.header("Tables")
    for (t,) in con.execute("SELECT name FROM sqlite_master WHERE type='table' AND name NOT LIKE 'sqlite_%'"):
        n = con.execute(f'SELECT COUNT(*) FROM "{t}"').fetchone()[0]
        with st.expander(f"{t} ({n} rows)"):
            for c in con.execute(f'PRAGMA table_info("{t}")'):
                st.text(f"{c[1]}  {c[2]}")
    if load_errors:
        st.warning(f"{len(load_errors)} statement(s) failed on import")
        with st.expander("Import errors"):
            st.text("\n".join(load_errors[:20]))

st.title("SQL Practice")
st.text_area("Questions (paste or type here)", height=150,
             placeholder="Paste your questions here...", key="questions")
query = st.text_area("SQL query", height=220, placeholder="Write or paste a SQL query, then click Run")

if st.button("Run", type="primary"):
    stmts = [s for s in split_statements(query) if strip_comments(s)]
    if not stmts:
        st.error("Type a query first.")
    elif any(not re.match(r"(SELECT|WITH|PRAGMA|EXPLAIN)\b", strip_comments(s), re.I) for s in stmts):
        st.error("Only read queries (SELECT / WITH) are allowed.")
    else:
        try:
            t0 = time.perf_counter()
            df = pd.read_sql_query(stmts[-1].rstrip(";"), con)
            st.caption(f"{len(df)} rows · {(time.perf_counter() - t0) * 1000:.1f} ms"
                       + (" · showing the last statement's result" if len(stmts) > 1 else ""))
            st.dataframe(df, width="stretch")
            st.download_button("Download CSV", df.to_csv(index=False), "results.csv", "text/csv")
        except Exception as e:
            st.error(str(e))
