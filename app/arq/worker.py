from arq import cron
from arq.connections import RedisSettings
from arq.typing import StartupShutdown

from app import crud, dataclasses
from app.core import settings
from app.core.dependencies import get_redis_with_context
from app.factories.suspicious_domains import SuspiciousDomainsFactory


async def startup(ctx: dict) -> None:
    pass


async def shutdown(ctx: dict) -> None:
    pass


async def save_newly_suspicious_domains_from_security_trails(
    _: dict,
) -> list[dataclasses.DomainWithVerdiction]:
    suspicious_domains = await SuspiciousDomainsFactory.from_security_trails()

    async with get_redis_with_context() as redis:
        await crud.redis.bulk_save(redis, suspicious_domains=suspicious_domains)

    return suspicious_domains


class ArqWorkerSettings:
    # default timeout = 300s, keep_result = 3600s
    redis_settings: RedisSettings = settings.REDIS_SETTINGS

    on_startup: StartupShutdown | None = startup
    on_shutdown: StartupShutdown | None = shutdown

    cron_jobs = [
        cron(
            save_newly_suspicious_domains_from_security_trails,
            hour=0,
            minute=0,
            run_at_startup=True,
        )
    ]
