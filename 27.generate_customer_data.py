from faker import Faker
import pandas as pd
import random


fake = Faker("en_IN")

customers = []

segments = [
    "Regular",
    "Premium",
    "VIP"
]

occupations = [
    "Software Engineer",
    "Teacher",
    "Doctor",
    "Business Owner",
    "Bank Employee",
    "Student",
    "Government Employee",
    "Analyst"
]


for customer_id in range(1, 501):

    customer = {

        "Customer_ID": customer_id,

        "Customer_Name": fake.name(),

        "Gender": random.choice(
            ["M", "F", "O"]
        ),

        "Date_of_Birth": fake.date_of_birth(
            minimum_age=18,
            maximum_age=65
        ),

        "Mobile_Number": fake.unique.msisdn()[:10],

        "Email_ID": fake.unique.email(),

        "Occupation": random.choice(
            occupations
        ),

        "City": fake.city(),

        "State_Name": fake.state(),

        "Customer_Segment": random.choice(
            segments
        )
    }

    customers.append(customer)


df = pd.DataFrame(customers)


df.to_csv(
    "../04_Dataset/customers.csv",
    index=False
)


print("500 customer records generated successfully")