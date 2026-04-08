from fastapi import APIRouter
from pydantic import BaseModel
import random
import time

router = APIRouter()

# ✅ Temporary Database
users_db = []
otp_db = {}

# ✅ Request Models
class OTPRequest(BaseModel):
    username: str
    mobile: str

class VerifyRequest(BaseModel):
    mobile: str
    otp: str


# ✅ SEND OTP API
@router.post("/auth/send-otp")
def send_otp(data: OTPRequest):

    # ✅ Check if user already exists
    for user in users_db:
        if user["username"] == data.username:
            return {"success": False, "message": "Username already exists ❌"}

        if user["mobile"] == data.mobile:
            return {"success": False, "message": "Mobile already exists ❌"}

    # ✅ Generate OTP
    otp = str(random.randint(1000, 9999))

    # ✅ Save OTP temporarily
    otp_db[data.mobile] = {
        "otp": otp,
        "expires": time.time() + 120   # 2 minutes expiry
    }

    print("✅ OTP Generated:", otp)

    return {
        "success": True,
        "message": "OTP Sent ✅",
        "otpTesting": otp   # Remove later in real app
    }


# ✅ VERIFY OTP API
@router.post("/auth/verify-otp")
def verify_otp(data: VerifyRequest):

    # ✅ Mobile not found
    if data.mobile not in otp_db:
        return {"success": False, "message": "OTP not sent ❌"}

    saved_otp = otp_db[data.mobile]["otp"]
    expiry = otp_db[data.mobile]["expires"]

    # ✅ Check Expiry
    if time.time() > expiry:
        return {"success": False, "message": "OTP Expired ❌"}

    # ✅ OTP mismatch
    if saved_otp != data.otp:
        return {"success": False, "message": "Invalid OTP ❌"}

    # ✅ OTP Verified → Register user
    users_db.append({
        "username": "NewUser",
        "mobile": data.mobile
    })

    otp_db.pop(data.mobile)

    return {
        "success": True,
        "message": "OTP Verified ✅ Login Success"
    }
