from typing import Optional

from arq import cron
from arq.connections import RedisSettings
from arq.typing import StartupShutdown

from app import dataclasses
from app.core.dependencies import get_redis_settings, get_redis_with_context
from app.factories.suspicious_domains import SuspiciousDomainsFactory
from app.redis import Redis


async def startup(ctx: dict) -> None:
    pass


async def shutdown(ctx: dict) -> None:
    pass


async def save_newly_suspicious_domains_from_security_trails(
    _: dict,
) -> list[dataclasses.DomainWithVerdiction]:
    suspicious_domains = await SuspiciousDomainsFactory.from_security_trails()

    async with get_redis_with_context() as redis:
        await Redis.save_suspicious_domains(suspicious_domains, redis=redis)

    return suspicious_domains


class ArqWorkerSettings:
    # default timeout = 300s, keep_result = 3600s
    redis_settings: RedisSettings = get_redis_settings()

    on_startup: Optional[StartupShutdown] = startup
    on_shutdown: Optional[StartupShutdown] = shutdown

    cron_jobs = [
        cron(
            save_newly_suspicious_domains_from_security_trails,
            hour=0,
            minute=0,
            run_at_startup=True,
        )
    ]
