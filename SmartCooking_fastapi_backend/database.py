from motor.motor_asyncio import AsyncIOMotorClient

MONGO_URL = "mongodb://localhost:27017"

client = AsyncIOMotorClient(MONGO_URL)

db = client["smartcookingDB"]

users_collection = db["users"]
recipe_collection = db["recipes"]