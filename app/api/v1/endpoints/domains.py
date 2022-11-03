import json

from fastapi import APIRouter, Depends
from fastapi_cache.coder import PickleCoder
from fastapi_cache.decorator import cache
from redis import asyncio as aioredis

from app import schemas
from app.core.dependencies import get_redis
from app.redis.constants import KEY_PREFIX

router = APIRouter()


@cache(coder=PickleCoder, expire=60 * 5)
async def _get_domains(redis: aioredis.Redis) -> list[schemas.Domain]:
    keys = await redis.keys(f"{KEY_PREFIX}*")
    if len(keys) == 0:
        return []

    values = await redis.mget(*keys)

    dicts: list[dict] = [json.loads(value) for value in values]
    return [schemas.Domain.parse_obj(d) for d in dicts]


@router.get(
    "/",
    summary="Get the latest suspicious domains",
    response_model=list[schemas.Domain],
)
async def get_domains(redis: aioredis.Redis = Depends(get_redis)):
    return await _get_domains(redis)
