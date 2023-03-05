import json

from redis.asyncio import Redis

from app import dataclasses
from app.core import settings


class CRUDRedis:
    async def bulk_save(
        self,
        redis: Redis,
        *,
        suspicious_domains: list[dataclasses.DomainWithVerdiction],
        expire: int = settings.REDIS_SUSPICIOUS_DOMAIN_TTL,
        key_prefix: str = settings.REDIS_SUSPICIOUS_DOMAIN_KEY_PREFIX
    ):
        async with redis.pipeline(transaction=True) as pipe:
            for domain in suspicious_domains:
                key = key_prefix + domain.fqdn
                value = json.dumps(domain.to_dict())
                pipe.set(key, value, ex=expire)

            await pipe.execute()


redis = CRUDRedis()
