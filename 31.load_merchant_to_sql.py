import pandas as pd
import pyodbc

print("===== Merchant ETL Started =====")

# ==========================================================
# 1. Read Merchant CSV
# ==========================================================

csv_path = "../04_Dataset/merchants.csv"

df = pd.read_csv(csv_path)

# Keep only required columns
df = df[
    [
        "Merchant_ID",
        "Merchant_Name",
        "Merchant_Category_ID",
        "Location_ID",
        "GST_Number"
    ]
]

# Remove empty rows
df = df.dropna()

# Convert data types
df["Merchant_ID"] = df["Merchant_ID"].astype(int)
df["Merchant_Category_ID"] = df["Merchant_Category_ID"].astype(int)
df["Location_ID"] = df["Location_ID"].astype(int)

print(f"CSV loaded successfully ({len(df)} records)")
print(df.head())

# ==========================================================
# 2. Connect to SQL Server
# ==========================================================

conn = pyodbc.connect(
    "Driver={ODBC Driver 18 for SQL Server};"
    "Server=Sabiha;"
    "Database=FinSight_EDIP;"
    "Trusted_Connection=yes;"
    "TrustServerCertificate=yes;"
)

cursor = conn.cursor()

print("Connected to SQL Server")

# ==========================================================
# 3. Delete Existing Data
# ==========================================================

cursor.execute("DELETE FROM dbo.Dim_Merchant")
conn.commit()

print("Existing merchant records deleted.")

# ==========================================================
# 4. Insert Merchant Records
# ==========================================================

insert_sql = """
INSERT INTO dbo.Dim_Merchant
(
    Merchant_ID,
    Merchant_Name,
    Merchant_Category_ID,
    Location_ID,
    GST_Number
)
VALUES (?, ?, ?, ?, ?)
"""

loaded = 0

for _, row in df.iterrows():

    cursor.execute(
        insert_sql,
        int(row["Merchant_ID"]),
        row["Merchant_Name"],
        int(row["Merchant_Category_ID"]),
        int(row["Location_ID"]),
        row["GST_Number"]
    )

    loaded += 1

# ==========================================================
# 5. Save Changes
# ==========================================================

conn.commit()

cursor.execute("SELECT COUNT(*) FROM dbo.Dim_Merchant")
merchant_count = cursor.fetchone()[0]

cursor.close()
conn.close()

print("--------------------------------")
print(f"Records Loaded : {loaded}")
print(f"Rows in SQL    : {merchant_count}")
print("Merchant ETL Completed Successfully!")
print("--------------------------------")