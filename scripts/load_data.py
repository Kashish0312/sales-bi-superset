import pandas as pd
from sqlalchemy import create_engine

CSV_PATH = "data/Sample - Superstore.csv"
DB_URL = "postgresql+psycopg2://analytics:analytics123@localhost:5433/salesdb"

# Load CSV
df = pd.read_csv(CSV_PATH, encoding="latin1")

# Clean column headers (strip spaces, lowercase, replace spaces/hyphens with _)
df.columns = (
    df.columns.str.strip()
    .str.lower()
    .str.replace(" ", "_")
    .str.replace("-", "_")
)

print("Detected columns:", list(df.columns))

# Map possible column names to our standard schema
col_map = {
    "order_id": "order_id",
    "order_date": "order_date",
    "category": "category",
    "sub_category": "sub_category",
    "sales": "sales",
    "quantity": "quantity",
    "profit": "profit",
}

# Keep only columns that exist in the map
selected_cols = [c for c in col_map.keys() if c in df.columns]
df = df[selected_cols]

# Clean data types
if "order_date" in df.columns:
    df["order_date"] = pd.to_datetime(df["order_date"], errors="coerce")
if "sales" in df.columns:
    df["sales"] = pd.to_numeric(df["sales"], errors="coerce")
if "quantity" in df.columns:
    df["quantity"] = pd.to_numeric(
        df["quantity"], errors="coerce", downcast="integer"
    )
if "profit" in df.columns:
    df["profit"] = pd.to_numeric(df["profit"], errors="coerce")

# Load into PostgreSQL
engine = create_engine(DB_URL)
df.to_sql("sales_orders", engine, if_exists="replace", index=False)

print(f"\nLoaded {len(df):,} rows into sales_orders.")
print(df.dtypes)