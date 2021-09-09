import sys
from typing import TextIO

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

# ST settings
SECURITYTRAILS_API_KEY = config("SECURITYTRAILS_API_KEY", cast=Secret, default="")
