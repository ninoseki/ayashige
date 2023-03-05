import hashlib

from aiocache import Cache, decorators
from aiocache.serializers import PickleSerializer

from app.core import settings


def default_key_builder(
    func,
    *args,
    **kwargs,
) -> str:
    return hashlib.md5(  # nosec:B303
        f"{func.__module__}:{func.__name__}:{args}:{kwargs}".encode()
    ).hexdigest()


class cached(decorators.cached):
    def __init__(
        self,
        ttl=settings.REDIS_CACHE_TTL,
        key_builder=default_key_builder,
        cache=Cache.REDIS,
        serializer=PickleSerializer(),
        plugins=None,
        alias=None,
        noself=False,
        namespace: str = settings.REDIS_CACHE_NAMESPACE,
        endpoint: str = settings.REDIS_URL.hostname or "localhost",
        port: int = settings.REDIS_URL.port or 6379,
        password: str | None = settings.REDIS_URL.password,
        **kwargs,
    ):
        super().__init__(
            ttl=ttl,
            key=None,
            key_builder=key_builder,
            noself=noself,
            alias=alias,
            cache=cache,
            serializer=serializer,
            plugins=plugins,
            namespace=namespace,
            endpoint=endpoint,
            port=port,
            password=password,
            **kwargs,
        )
