import random
from datetime import datetime, timedelta

def generate_otp():
    otp = random.randint(1000, 9999)
    expiry = datetime.utcnow() + timedelta(minutes=2)
    return str(otp), expiry
