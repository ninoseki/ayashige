import sys
from typing import TextIO

from arq.connections import RedisSettings
from starlette.config import Config
from starlette.datastructures import Secret

from app.core.datastructures import DatabaseURL

config = Config(".env")

# general settings
PROJECT_NAME: str = config("PROJECT_NAME", cast=str, default="Ayashige")
VERSION: str = config("VERSION", cast=str, default="0.1.0")
DESCRIPTION: str = config(
    "DESCRIPTION",
    cast=str,
    default="Ayashige provides a list of suspicious newly updated domains as a JSON feed",
)

DEBUG: bool = config("DEBUG", cast=bool, default=False)
TESTING: bool = config("TESTING", cast=bool, default=False)

# log settings
LOG_FILE: TextIO = config("LOG_FILE", default=sys.stderr)
LOG_LEVEL: str = config("LOG_LEVEL", cast=str, default="DEBUG")
LOG_BACKTRACE: bool = config("LOG_BACKTRACE", cast=bool, default=True)

# Redis settings
REDIS_URL: DatabaseURL = config(
    "REDIS_URL", cast=DatabaseURL, default="redis://localhost:6379"
)

REDIS_CACHE_TTL: int = config(
    "REDIS_CACHE_TTL",
    cast=int,
    default=60 * 60,
)
REDIS_CACHE_NAMESPACE: str = config("REDIS_CACHE_NAMESPACE", cast=str, default="cache")
REDIS_CACHE_PREFIX: str = config(
    "REDIS_CACHE_PREFIX", cast=str, default="fastapi-cache"
)

REDIS_SETTINGS = RedisSettings(
    host=REDIS_URL.hostname or "localhost",
    port=REDIS_URL.port or 6379,
    password=REDIS_URL.password,
)

REDIS_SUSPICIOUS_DOMAIN_KEY_PREFIX: str = config(
    "REDIS_SUSPICIOUS_DOMAIN_KEY_PREFIX", cast=str, default="domain:"
)
REDIS_SUSPICIOUS_DOMAIN_TTL: int = config(
    "REDIS_SUSPICIOUS_DOMAIN_TTL", cast=int, default=60 * 60 * 24
)

# ST settings
SECURITY_TRAILS_API_KEY = config("SECURITY_TRAILS_API_KEY", cast=Secret, default="")
