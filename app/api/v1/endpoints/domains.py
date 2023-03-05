import json

from fastapi import APIRouter, Depends
from redis.asyncio import Redis

from app import schemas
from app.cache import cached
from app.core import settings
from app.core.dependencies import get_redis

router = APIRouter()


@cached(ttl=60 * 5)
async def _get_domains(redis: Redis) -> list[schemas.Domain]:
    keys = await redis.keys(f"{settings.REDIS_SUSPICIOUS_DOMAIN_KEY_PREFIX}*")
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
async def get_domains(redis: Redis = Depends(get_redis)):
    return await _get_domains(redis)
