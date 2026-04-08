from fastapi import APIRouter
from database import recipe_collection
from models.recipe_model import Recipe
from datetime import datetime, timedelta
from fastapi import UploadFile, File

router = APIRouter()


# ✅ AUTO CATEGORY DETECTION
def detect_category(recipe_name: str):

    name = recipe_name.lower()

    if any(x in name for x in ["idli", "dosa", "upma", "poha", "vada", "pongal"]):
        return "Tiffin"

    if any(x in name for x in ["biryani", "rice", "pulav", "fried rice", "khichdi"]):
        return "Lunch"

    if any(x in name for x in ["curry", "dal", "roti", "chapati", "paneer", "sabzi"]):
        return "Dinner"

    return "More"


# ✅ SYSTEM RECIPES (Fixed)
system_recipes = [

    # ✅ Lunch Recipes
    {
        "recipeId": "SYS001",
        "name": "Chicken Biryani",
        "country": "India",
        "category": "Lunch",
        "cookTime": 50,
        "image": "https://via.placeholder.com/200",
        "ingredients": [
            "Chicken - 200 g",
            "Basmati Rice - 150 g",
            "Onion - 100 g",
            "Tomato - 60 g",
            "Yogurt - 80 g",
            "Ginger Garlic Paste - 10 g",
            "Biryani Masala - 6 g",
            "Green Chilli - 5 g",
            "Mint Leaves - 10 g",
            "Oil/Ghee - 15 g",
            "Salt - 3 g"
        ],
        "steps": [
            "Wash rice and soak for 20 minutes.",
            "Marinate chicken with spices.",
            "Fry onions till golden brown.",
            "Add chicken and cook for 15 minutes.",
            "Cook rice till 70% done.",
            "Layer rice and chicken.",
            "Cook on low flame for 20 minutes.",
            "Serve hot with raita."
        ],
        "type": "system"
    },

    {
        "recipeId": "SYS002",
        "name": "Egg Biryani",
        "country": "India",
        "category": "Lunch",
        "cookTime": 40,
        "image": "https://via.placeholder.com/200",
        "ingredients": [
            "Eggs - 2 boiled",
            "Rice - 150 g",
            "Onion - 80 g",
            "Tomato - 50 g",
            "Biryani Masala - 5 g",
            "Oil - 12 g",
            "Salt - 3 g",
            "Mint Leaves - 5 g"
        ],
        "steps": [
            "Boil eggs and cut slightly.",
            "Fry onions until golden.",
            "Add tomatoes and spices.",
            "Add boiled eggs and mix gently.",
            "Cook rice till 70%.",
            "Layer rice and masala.",
            "Cook for 15 minutes.",
            "Serve hot."
        ],
        "type": "system"
    },

    # ✅ Dinner Recipes
    {
        "recipeId": "SYS004",
        "name": "Chicken Curry",
        "country": "India",
        "category": "Dinner",
        "cookTime": 35,
        "image": "https://via.placeholder.com/200",
        "ingredients": [
            "Chicken - 200 g",
            "Onion - 100 g",
            "Tomato - 70 g",
            "Oil - 15 g",
            "Curry Powder - 5 g",
            "Ginger Garlic Paste - 8 g",
            "Salt - 3 g",
            "Water - 200 ml"
        ],
        "steps": [
            "Heat oil and fry onions.",
            "Add ginger garlic paste.",
            "Add tomatoes and cook.",
            "Add spices and chicken.",
            "Cook for 10 minutes.",
            "Add water and simmer 20 minutes.",
            "Serve hot."
        ],
        "type": "system"
    },

    # ✅ Tiffin Recipes
    {
        "recipeId": "SYS006",
        "name": "Plain Dosa",
        "country": "India",
        "category": "Tiffin",
        "cookTime": 20,
        "image": "https://via.placeholder.com/200",
        "ingredients": [
            "Dosa Batter - 200 g",
            "Salt - 2 g",
            "Oil or Ghee - 10 g"
        ],
        "steps": [
            "Heat tawa on medium flame.",
            "Spread batter in circle.",
            "Drizzle oil and cook golden.",
            "Fold and serve hot."
        ],
        "type": "system"
    },

    {
        "recipeId": "SYS007",
        "name": "Soft Idli",
        "country": "India",
        "category": "Tiffin",
        "cookTime": 15,
        "image": "https://via.placeholder.com/200",
        "ingredients": [
            "Idli Batter - 250 g",
            "Salt - 2 g",
            "Water - 500 ml"
        ],
        "steps": [
            "Grease moulds and pour batter.",
            "Steam for 12 minutes.",
            "Serve with chutney."
        ],
        "type": "system"
    },

    {
        "recipeId": "SYS008",
        "name": "Rava Upma",
        "country": "India",
        "category": "Tiffin",
        "cookTime": 20,
        "image": "https://via.placeholder.com/200",
        "ingredients": [
            "Rava - 80 g",
            "Water - 300 ml",
            "Onion - 50 g",
            "Oil - 10 g",
            "Salt - 2 g"
        ],
        "steps": [
            "Roast rava lightly.",
            "Boil water with salt.",
            "Add rava slowly stirring.",
            "Cook 5 minutes and serve."
        ],
        "type": "system"
    },

    # ✅ Seasonal Recipes
    {
        "recipeId": "SYS100",
        "name": "Mango Juice",
        "country": "India",
        "category": "More",
        "season": "Summer",
        "cookTime": 5,
        "image": "https://via.placeholder.com/200",
        "ingredients": [
            "Mango - 1",
            "Water - 200 ml",
            "Sugar - 10 g"
        ],
        "steps": [
            "Peel mango and cut pieces.",
            "Blend with water and sugar.",
            "Serve chilled."
        ],
        "type": "system"
    },

    {
        "recipeId": "SYS101",
        "name": "Masala Tea",
        "country": "India",
        "category": "More",
        "season": "Winter",
        "cookTime": 8,
        "image": "https://via.placeholder.com/200",
        "ingredients": [
            "Milk - 200 ml",
            "Tea powder - 5 g",
            "Sugar - 10 g"
        ],
        "steps": [
            "Boil milk.",
            "Add tea powder and sugar.",
            "Serve hot."
        ],
        "type": "system"
    },

    # ✅ Festival Recipes
    {
        "recipeId": "SYS200",
        "name": "Ugadi Pachadi",
        "country": "India",
        "category": "More",
        "festival": "Ugadi",
        "festivalDate": "2026-03-19",
        "cookTime": 20,
        "image": "https://via.placeholder.com/200",
        "ingredients": [
            "Neem Flowers - 5 g",
            "Jaggery - 30 g",
            "Raw Mango - 50 g"
        ],
        "steps": [
            "Mix all ingredients well.",
            "Serve fresh."
        ],
        "type": "system"
    }
]


# ✅ Insert System Recipes Only Once
async def add_system_recipes():
    for recipe in system_recipes:

        await recipe_collection.update_one(
            {"recipeId": recipe["recipeId"]},
            {"$set": recipe},
            upsert=True
        )

    print("✅ System Recipes Synced Successfully")



# ✅ GET ALL RECIPES
@router.get("/")
async def get_all_recipes():
    await add_system_recipes()
    recipes = await recipe_collection.find({}, {"_id": 0}).to_list(200)
    return {"success": True, "recipes": recipes}


# ✅ Seasonal Recipes API
@router.get("/more/seasonal")
async def seasonal_recipes():
    month = datetime.now().month

    if month in [3, 4, 5, 6]:
        current_season = "Summer"
    elif month in [7, 8, 9, 10]:
        current_season = "Rainy"
    else:
        current_season = "Winter"

    recipes = await recipe_collection.find(
        {"season": current_season},
        {"_id": 0}
    ).to_list(50)

    return {"success": True, "season": current_season, "recipes": recipes}


# ✅ Festival Recipes API
@router.get("/more/festival")
async def festival_recipes():

    today = datetime.now().date()
    next_week = today + timedelta(days=7)

    all_festivals = await recipe_collection.find(
        {"festivalDate": {"$exists": True}},
        {"_id": 0}
    ).to_list(50)

    upcoming = []

    for r in all_festivals:
        try:
            fest_date = datetime.strptime(
                r["festivalDate"], "%Y-%m-%d"
            ).date()

            if today <= fest_date <= next_week:
                upcoming.append(r)

        except Exception as e:
            print("❌ Date parse error:", e)

    return {
        "success": True,
        "today": str(today),
        "next_week": str(next_week),
        "recipes": upcoming
    }

@router.get("/more/quick")
async def quick_recipes():

    recipes = await recipe_collection.find(
        {}, {"_id": 0}
    ).sort("cookTime", 1).to_list(20)

    return {
        "success": True,
        "recipes": recipes
    }


# ✅ Add User Recipe
@router.post("/add")
async def add_recipe(recipe: Recipe):
    data = recipe.dict()
    data["category"] = detect_category(data["name"])
    data["type"] = "user"
    await recipe_collection.insert_one(data)
    return {"success": True, "message": "Recipe Added ✅"}

# ✅ GET ALL RECIPES (System + User)
@router.get("/")
async def get_all_recipes():
    await add_system_recipes()

    recipes = await recipe_collection.find(
        {}, {"_id": 0}
    ).to_list(200)

    return {"success": True, "recipes": recipes}


# ✅ GET ONLY USER RECIPES (My Recipes)
@router.get("/user")
async def get_user_recipes():

    recipes = await recipe_collection.find(
        {"type": "user"},   # ✅ Only user entered recipes
        {"_id": 0}
    ).to_list(200)

    return {"success": True, "recipes": recipes}

# ✅ UPDATE USER RECIPE
@router.put("/update/{recipeId}")
async def update_recipe(recipeId: str, recipe: Recipe):

    data = recipe.dict()

    # ✅ Auto category again
    data["category"] = detect_category(data["name"])
    data["type"] = "user"

    result = await recipe_collection.update_one(
        {"recipeId": recipeId, "type": "user"},
        {"$set": data}
    )

    if result.matched_count == 0:
        return {
            "success": False,
            "message": "Recipe Not Found ❌"
        }

    return {
        "success": True,
        "message": "Recipe Updated ✅"
    }

# ✅ DELETE USER RECIPE
@router.delete("/delete/{recipeId}")
async def delete_recipe(recipeId: str):

    result = await recipe_collection.delete_one(
        {"recipeId": recipeId, "type": "user"}
    )

    if result.deleted_count == 0:
        return {
            "success": False,
            "message": "Recipe Not Found ❌"
        }

    return {
        "success": True,
        "message": "Recipe Deleted ✅"
    }

@router.get("/search/by-ingredients")
async def search_by_ingredients(items: str):
    """
    Example:
    /search/by-ingredients?items=rice,tomato,onion
    """

    ingredient_list = [x.strip().lower() for x in items.split(",")]

    all_recipes = await recipe_collection.find({}, {"_id": 0}).to_list(200)

    matched = []

    for recipe in all_recipes:
        recipe_ingredients = [
            ing.lower() for ing in recipe.get("ingredients", [])
        ]

        # ✅ Check if ALL searched ingredients exist
        if all(any(item in ing for ing in recipe_ingredients)
               for item in ingredient_list):
            matched.append(recipe)

    return {
        "success": True,
        "count": len(matched),
        "recipes": matched
    }

@router.get("/search")
async def search_recipe(query: str):
    recipes = await recipe_collection.find(
        {"name": {"$regex": query, "$options": "i"}},
        {"_id": 0}
    ).to_list(50)

    return {"success": True, "recipes": recipes}

@router.post("/voice/command")
async def tara_command(data: dict):

    text = data.get("text", "").lower()

    # ✅ Search Recipe Command
    if "search" in text:
        query = text.replace("search", "").strip()

        recipes = await recipe_collection.find(
            {"name": {"$regex": query, "$options": "i"}},
            {"_id": 0}
        ).to_list(10)

        return {
            "success": True,
            "action": "search",
            "recipes": recipes
        }

    # ✅ Category Commands
    elif "tiffin" in text:
        recipes = await recipe_collection.find(
            {"category": "Tiffin"},
            {"_id": 0}
        ).to_list(10)

        return {
            "success": True,
            "action": "category",
            "recipes": recipes
        }

    elif "lunch" in text:
        recipes = await recipe_collection.find(
            {"category": "Lunch"},
            {"_id": 0}
        ).to_list(10)

        return {
            "success": True,
            "action": "category",
            "recipes": recipes
        }

    elif "dinner" in text:
        recipes = await recipe_collection.find(
            {"category": "Dinner"},
            {"_id": 0}
        ).to_list(10)

        return {
            "success": True,
            "action": "category",
            "recipes": recipes
        }

    return {
        "success": False,
        "message": "Tara didn't understand the command"
    }

@router.post("/food/detect")
async def detect_food(image: UploadFile = File(...)):
    return {"foodName": "biryani"}
