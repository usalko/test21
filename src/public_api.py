# public_api.py
from fastapi import FastAPI

public_app = FastAPI()

@public_app.get('/')
async def home():
    return {'description': 'PUBLIC API'}

# [GET] /memes (list with pagination)

# [GET] /memes/{id}

# [POST] /memes

# [PUT] /memes/{id}

# [DELETE] /memes/{id}