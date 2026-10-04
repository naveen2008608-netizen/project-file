from fastapi import FastAPI
from fastapi.middleware.cors import CORSMiddleware
from pydantic import BaseModel


app = FastAPI(
    title="IRTC Water Management API",
    version="1.0.0"
)


# Allow Flutter to connect
app.add_middleware(
    CORSMiddleware,
    allow_origins=["*"],
    allow_credentials=True,
    allow_methods=["*"],
    allow_headers=["*"],
)


# -----------------------------
# LOGIN REQUEST
# -----------------------------

class LoginRequest(BaseModel):
    user_id: str
    password: str
    branch: str


# -----------------------------
# HOME / SERVER TEST
# -----------------------------

@app.get("/")
def root():
    return {
        "status": "online",
        "application": "IRTC Water Management API",
        "version": "1.0.0"
    }


# -----------------------------
# LOGIN
# -----------------------------

@app.post("/login")
def login(data: LoginRequest):

    valid_branches = [
        "Track Detector",
        "Track Mentor",
        "Water Management"
    ]

    if (
        data.user_id == "naveen02"
        and data.password == "2008"
        and data.branch in valid_branches
    ):
        return {
            "success": True,
            "message": "Login successful",
            "user_id": data.user_id,
            "branch": data.branch
        }

    return {
        "success": False,
        "message": "Invalid User ID, Password or Branch"
    }