from collections.abc import Callable, Coroutine
from typing import Any

from fastapi import FastAPI


def create_start_app_handler(
    app_: FastAPI,
) -> Callable[[], Coroutine[Any, Any, None]]:
    async def start_app() -> None:
        pass

    return start_app


def create_stop_app_handler(
    app_: FastAPI,
) -> Callable[[], Coroutine[Any, Any, None]]:
    async def stop_app() -> None:
        pass

    return stop_app
