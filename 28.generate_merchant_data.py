from faker import Faker
import pandas as pd
import random


fake = Faker("en_IN")


merchants = []


merchant_names = [
    "Reliance Digital",
    "More Supermarket",
    "Apollo Pharmacy",
    "Swiggy",
    "Zomato",
    "Croma",
    "Lifestyle",
    "PVR Cinemas",
    "MakeMyTrip",
    "DMart",
    "Big Bazaar",
    "Decathlon"
]


for merchant_id in range(1, 201):

    merchant = {

        "Merchant_ID": merchant_id,

        "Merchant_Name": random.choice(
            merchant_names
        ),

        "Merchant_Category_ID": random.randint(
            1,7
        ),

        "Location_ID": random.randint(
            1,10
        ),

        "GST_Number": fake.unique.bothify(
            text="##????#####"
        )

    }

    merchants.append(merchant)


df = pd.DataFrame(merchants)


df.to_csv(
    "../04_Dataset/merchants.csv",
    index=False
)


print("200 merchant records generated successfully")
