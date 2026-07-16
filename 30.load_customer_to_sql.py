import pandas as pd
import pyodbc


print("ETL process started...")


# ==========================================================
# 1. Read Customer CSV
# ==========================================================

csv_path = "../04_Dataset/customers.csv"

df = pd.read_csv(
    csv_path,
    usecols=[
        "Customer_ID",
        "Customer_Name",
        "Gender",
        "Date_of_Birth",
        "Mobile_Number",
        "Email_ID",
        "Occupation",
        "City",
        "State_Name",
        "Customer_Segment"
    ]
)


# Remove empty records
df = df.dropna()


# Data type cleaning

df["Customer_ID"] = df["Customer_ID"].astype(int)

df["Date_of_Birth"] = pd.to_datetime(
    df["Date_of_Birth"],
    errors="coerce"
).dt.date


print("CSV loaded successfully")
print("Total Records:", len(df))
print(df.head())


# ==========================================================
# 2. SQL Server Connection
# ==========================================================

connection = pyodbc.connect(
    "Driver={ODBC Driver 18 for SQL Server};"
    "Server=Sabiha;"
    "Database=FinSight_EDIP;"
    "Trusted_Connection=yes;"
    "TrustServerCertificate=yes;"
)


cursor = connection.cursor()

print("SQL Server connected successfully")


# ==========================================================
# 3. Insert Data
# ==========================================================

insert_query = """

INSERT INTO dbo.Dim_Customer
(
    Customer_ID,
    Customer_Name,
    Gender,
    Date_of_Birth,
    Mobile_Number,
    Email_ID,
    Occupation,
    City,
    State_Name,
    Customer_Segment
)

VALUES
(?,?,?,?,?,?,?,?,?,?)

"""


for _, row in df.iterrows():

    cursor.execute(
        insert_query,

        row["Customer_ID"],
        row["Customer_Name"],
        row["Gender"],
        row["Date_of_Birth"],
        row["Mobile_Number"],
        row["Email_ID"],
        row["Occupation"],
        row["City"],
        row["State_Name"],
        row["Customer_Segment"]
    )


# ==========================================================
# 4. Save Changes
# ==========================================================

connection.commit()

cursor.close()
connection.close()


print("Customer data loaded successfully!")