import json

import aioredis

from app import dataclasses

from .constants import DEFAULT_TTL, KEY_PREFIX


async def save_suspicious_domains(
    suspicious_domains: list[dataclasses.DomainWithVerdiction], *, redis: aioredis.Redis
):
    tr = redis.multi_exec()

    for domain in suspicious_domains:
        key = KEY_PREFIX + domain.fqdn
        value = json.dumps(domain.to_dict())
        tr.set(key, value, expire=DEFAULT_TTL)

    await tr.execute()
