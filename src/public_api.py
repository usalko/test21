# public_api.py
from fastapi import FastAPI

public_app = FastAPI()

@public_app.get('/')
async def home():
    return {'message': 'ok'}
