# private_api.py
from fastapi import FastAPI
from miniopy_async import Minio

private_app = FastAPI()

async_minio_client = Minio(
    "play.min.io",
    access_key="Q3AM3UQ867SPQQA43P2F",
    secret_key="zuf+tfteSlswRu7BJ86wekitnifILbZam1KYY3TG",
    secure=True  # http for False, https for True
)

@private_app.get('/')
async def home():
    return {'description': 'PRIVATE API'}

# [PUT] /images

# [GET] /images/{image_id}