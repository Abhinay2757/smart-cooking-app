from fastapi import FastAPI, File, UploadFile
from pydantic import BaseModel
import shutil
import os
import random
from fastapi.middleware.cors import CORSMiddleware

from routes.recipe_routes import router as recipe_router

from fastapi.staticfiles import StaticFiles

app = FastAPI()

# ✅ Enable CORS for Flutter
app.add_middleware(
    CORSMiddleware,
    allow_origins=["*"],
    allow_credentials=True,
    allow_methods=["*"],
    allow_headers=["*"],
)

# ✅ Temporary OTP Store
otp_store = {}

# ✅ OTP Models
class SendOtpRequest(BaseModel):
    username: str
    mobile: str

class VerifyOtpRequest(BaseModel):
    mobile: str
    otp: str


# ✅ HOME API
@app.get("/")
def home():
    return {"message": "✅ SmartCooking Backend Running"}


# ✅ SEND OTP API
@app.post("/auth/send-otp")
def send_otp(data: SendOtpRequest):

    otp = str(random.randint(1000, 9999))
    otp_store[data.mobile] = otp

    print("✅ OTP Generated:", otp)

    return {
        "success": True,
        "message": "OTP Sent Successfully ✅",
        "demoOtp": otp
    }


# ✅ VERIFY OTP API
@app.post("/auth/verify-otp")
def verify_otp(data: VerifyOtpRequest):

    stored_otp = otp_store.get(data.mobile)

    if stored_otp == data.otp:
        return {"success": True, "message": "OTP Verified ✅"}

    return {"success": False, "message": "Invalid OTP ❌"}


# ✅ INCLUDE RECIPE ROUTES
app.include_router(
    recipe_router,
    prefix="/api/recipes",
    tags=["Recipes"]
)

UPLOAD_FOLDER = "uploads"
os.makedirs(UPLOAD_FOLDER, exist_ok=True)

@app.post("/upload/")
async def upload_image(file: UploadFile = File(...)):
    file_path = f"{UPLOAD_FOLDER}/{file.filename}"

    with open(file_path, "wb") as buffer:
        shutil.copyfileobj(file.file, buffer)

    return {"image_url": file_path}

app.mount("/uploads", StaticFiles(directory="uploads"), name="uploads")