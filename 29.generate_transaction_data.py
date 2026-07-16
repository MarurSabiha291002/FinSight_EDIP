import pandas as pd
import random
from faker import Faker

fake = Faker("en_IN")

TOTAL_TRANSACTIONS = 50000

transactions = []

payment_methods = [1, 2, 3, 4, 5, 6]
payment_weights = [45, 20, 15, 8, 7, 5]

status_values = ["Success", "Failed", "Refunded"]
status_weights = [96, 3, 1]


def generate_amount():

    chance = random.randint(1, 100)

    if chance <= 35:
        return round(random.uniform(50, 500), 2)

    elif chance <= 65:
        return round(random.uniform(500, 2000), 2)

    elif chance <= 90:
        return round(random.uniform(2000, 10000), 2)

    else:
        return round(random.uniform(10000, 50000), 2)


for transaction_id in range(1, TOTAL_TRANSACTIONS + 1):

    transaction = {

        "Transaction_ID": transaction_id,

        "Date_ID": random.randint(1, 365),

        "Customer_ID": random.randint(1, 500),

        "Merchant_ID": random.randint(1, 200),

        "Payment_Method_ID": random.choices(
            payment_methods,
            weights=payment_weights,
            k=1
        )[0],

        "Location_ID": random.randint(1, 10),

        "Transaction_Amount": generate_amount(),

        "Transaction_Status": random.choices(
            status_values,
            weights=status_weights,
            k=1
        )[0],

        "Transaction_Reference": fake.unique.bothify(
            text="TXN##########"
        )

    }

    transactions.append(transaction)


df = pd.DataFrame(transactions)

df.to_csv(
    "../04_Dataset/transactions.csv",
    index=False
)

print(f"{TOTAL_TRANSACTIONS} transaction records generated successfully!")