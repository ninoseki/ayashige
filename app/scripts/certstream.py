import asyncio
from typing import Any, Dict, List

from loguru import logger

from app import dataclasses
from app.core.dependencies import get_redis_with_context
from app.factories.suspicious_domains import SuspiciousDomainsFactory
from app.redis import Redis
from app.services import certstream


async def save_suspicious_domains(
    suspicious_domains: List[dataclasses.DomainWithVerdiction],
):
    async with get_redis_with_context() as redis:
        await Redis.save_suspicious_domains(suspicious_domains, redis=redis)


def message_callback(message: Dict[str, Any]):
    # check update message only
    update_message = dataclasses.CertStreamUpdateMessage.from_dict(message)
    if update_message is None:
        return

    suspicious_domains = SuspiciousDomainsFactory.from_list(
        update_message.data.leaf_cert.all_domains, "CT log"
    )
    if len(suspicious_domains) == 0:
        logger.info(
            f"Suspicious domains are not found from {update_message.data.cert_link}"
        )
        return

    logger.info(
        f"Suspicious domains are found from {update_message.data.cert_link}: {suspicious_domains}"
    )

    loop = asyncio.get_event_loop()
    loop.run_until_complete(save_suspicious_domains(suspicious_domains))


def main():
    certstream.listen_for_events(
        message_callback,
        url="wss://certstream.calidog.io/",
    )


main()
