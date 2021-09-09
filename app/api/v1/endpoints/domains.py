import json
from typing import List

import aioredis
from fastapi import APIRouter, Depends

from app import schemas
from app.core.dependencies import get_redis
from app.redis.constants import KEY_PREFIX

router = APIRouter()


@router.get(
    "/",
    summary="Get the latest suspicious domains",
    response_model=List[schemas.Domain],
)
async def get_domains(redis: aioredis.Redis = Depends(get_redis)):
    keys = await redis.keys(f"{KEY_PREFIX}*")
    if len(keys) == 0:
        return []

    values = await redis.mget(*keys)

    dicts: List[dict] = [json.loads(value) for value in values]
    return [schemas.Domain.parse_obj(d) for d in dicts]
