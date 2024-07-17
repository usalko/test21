# private_api.py
from fastapi import FastAPI

private_app = FastAPI()

@private_app.get('/')
async def home():
    return {'message': 'ok'}
