from pydantic import BaseModel
from typing import List, Optional

class Recipe(BaseModel):
    recipeId: str
    name: str
    country: str
    image: str
    ingredients: List[str]
    steps: List[str]

    cookTime: Optional[int] = None   # ✅ ADD THIS

    category: Optional[str] = None
    season: Optional[str] = None
    festival: Optional[str] = None
    festivalDate: Optional[str] = None

    type: str
