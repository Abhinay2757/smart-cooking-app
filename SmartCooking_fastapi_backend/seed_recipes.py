from database import recipe_collection

recipes = []

for i in range(1, 101):
    recipes.append({
        "recipeId": f"REC{i:03}",
        "name": f"Starter Recipe {i}",
        "country": "India" if i <= 50 else "Other",

        "image": "https://via.placeholder.com/200",

        "ingredients": [
            "Ingredient 1",
            "Ingredient 2",
            "Ingredient 3"
        ],

        "steps": [
            "Step 1: Prepare ingredients",
            "Step 2: Cook properly",
            "Step 3: Serve hot"
        ]
    })

# Clear old data
recipe_collection.delete_many({})

# Insert new recipes
recipe_collection.insert_many(recipes)

print("✅ 100 Recipes Inserted Successfully")
