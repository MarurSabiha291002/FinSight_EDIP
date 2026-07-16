import pandas as pd
import pyodbc

print("===== Transaction ETL Started =====")

# ==========================================================
# Read CSV
# ==========================================================

df = pd.read_csv("../04_Dataset/transactions.csv")

print(f"CSV Records : {len(df)}")
print(df.head())

# ==========================================================
# Connect SQL Server
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
# Delete Old Transactions
# ==========================================================

cursor.execute("DELETE FROM dbo.Fact_Transactions")
conn.commit()

print("Old transaction records deleted.")

# ==========================================================
# Insert Records
# ==========================================================

insert_sql = """
INSERT INTO dbo.Fact_Transactions
(
    Transaction_ID,
    Date_ID,
    Customer_ID,
    Merchant_ID,
    Payment_Method_ID,
    Location_ID,
    Transaction_Amount,
    Transaction_Status,
    Transaction_Reference
)
VALUES (?,?,?,?,?,?,?,?,?)
"""

loaded = 0

for _, row in df.iterrows():

    cursor.execute(
        insert_sql,
        int(row["Transaction_ID"]),
        int(row["Date_ID"]),
        int(row["Customer_ID"]),
        int(row["Merchant_ID"]),
        int(row["Payment_Method_ID"]),
        int(row["Location_ID"]),
        float(row["Transaction_Amount"]),
        row["Transaction_Status"],
        row["Transaction_Reference"]
    )

    loaded += 1

conn.commit()

cursor.execute("SELECT COUNT(*) FROM dbo.Fact_Transactions")
count = cursor.fetchone()[0]

cursor.close()
conn.close()

print("--------------------------------")
print(f"Records Loaded : {loaded}")
print(f"Rows in SQL    : {count}")
print("Transaction ETL Completed Successfully!")
print("--------------------------------")