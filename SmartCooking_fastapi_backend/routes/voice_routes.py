from fastapi import APIRouter
from database import recipe_collection

router = APIRouter()

@router.post("/voice/command")
async def tara_command(data: dict):

    command = data.get("text", "").lower()

    # ✅ Search Recipe Command
    if "search" in command:
        query = command.replace("search", "").strip()

        recipes = await recipe_collection.find(
            {"name": {"$regex": query, "$options": "i"}},
            {"_id": 0}
        ).to_list(10)

        return {
            "success": True,
            "action": "search",
            "recipes": recipes
        }

    # ✅ Ingredient Search
    if "ingredients" in command:
        items = command.replace("ingredients", "").strip().split(",")

        recipes = await recipe_collection.find(
            {"ingredients": {"$in": items}},
            {"_id": 0}
        ).to_list(10)

        return {
            "success": True,
            "action": "ingredients",
            "recipes": recipes
        }

    return {
        "success": False,
        "message": "Command not understood"
    }
