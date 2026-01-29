#!/usr/bin/env python3
"""
Demo TechTutors Backend - No AWS Required
Run this for a quick demo without AWS Bedrock
"""

from fastapi import FastAPI, WebSocket
from fastapi.middleware.cors import CORSMiddleware
from fastapi.responses import JSONResponse
import uvicorn
import json
import uuid
from datetime import datetime

app = FastAPI(title="TechTutors Demo API")

# CORS
app.add_middleware(
    CORSMiddleware,
    allow_origins=["http://localhost:3000"],
    allow_credentials=True,
    allow_methods=["*"],
    allow_headers=["*"],
)

# Demo responses
DEMO_RESPONSES = [
    "What do you think might be causing this 403 error? Let's explore the AWS permissions model together.",
    "Interesting! When AWS returns a 403, what are the two main things it's checking?",
    "Good question! How does AWS determine if you have permission to access a resource?",
    "Let's think about this step by step. What role is your application using to access S3?",
    "That's a great observation! What's the difference between IAM policies and bucket policies?"
]

@app.get("/")
async def root():
    return {"message": "TechTutors Demo API - No AWS Required"}

@app.get("/health")
async def health():
    return {"status": "healthy", "mode": "demo"}

@app.post("/api/session/create")
async def create_session():
    return {
        "session_id": str(uuid.uuid4()),
        "created_at": datetime.now().isoformat()
    }

@app.websocket("/ws/{session_id}")
async def websocket_endpoint(websocket: WebSocket, session_id: str):
    await websocket.accept()
    response_index = 0
    
    try:
        while True:
            data = await websocket.receive_json()
            
            # Demo Socratic response
            response = {
                "type": "socratic_response",
                "content": DEMO_RESPONSES[response_index % len(DEMO_RESPONSES)],
                "hint_level": min(response_index + 1, 3),
                "has_more_hints": response_index < 4,
                "session_id": session_id
            }
            
            await websocket.send_text(json.dumps(response))
            response_index += 1
            
    except Exception as e:
        print(f"WebSocket error: {e}")

if __name__ == "__main__":
    print("🚀 Starting TechTutors Demo Backend...")
    print("📱 Frontend will be at: http://localhost:3000")
    print("🔧 This is a demo - no AWS required!")
    uvicorn.run(app, host="0.0.0.0", port=8000)