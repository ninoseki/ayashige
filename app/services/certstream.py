import json
import time
from collections.abc import Callable

from loguru import logger
from websocket import WebSocketApp


class CertStreamClient(WebSocketApp):
    def __init__(
        self,
        message_callback: Callable,
        url: str,
        skip_heartbeats: bool = True,
        on_open: Callable | None = None,
        on_error: Callable | None = None,
    ):
        self.message_callback = message_callback
        self.skip_heartbeats = skip_heartbeats
        self.on_open_handler = on_open
        self.on_error_handler = on_error

        super().__init__(
            url=url,
            on_open=self._on_open,
            on_message=self._on_message,
            on_error=self._on_error,
        )

    def _on_open(self, _):
        logger.info("Connection established to CertStream! Listening for events...")

        if self.on_open_handler:
            self.on_open_handler()

    def _on_message(self, _, message: str):
        frame = json.loads(message)

        if frame.get("message_type", None) == "heartbeat" and self.skip_heartbeats:
            return

        self.message_callback(frame)

    def _on_error(self, _, ex: type[Exception]):
        if type(ex) == KeyboardInterrupt:
            raise

        if self.on_error_handler:
            self.on_error_handler(ex)

        logger.error(
            f"Error connecting to CertStream - {ex} - Sleeping for a few seconds and trying again..."
        )


def listen_for_events(
    message_callback: Callable,
    url: str,
    skip_heartbeats: bool = True,
    on_open: Callable | None = None,
    on_error: Callable | None = None,
    **kwargs,
):
    try:
        while True:
            c = CertStreamClient(
                message_callback,
                url,
                skip_heartbeats=skip_heartbeats,
                on_open=on_open,
                on_error=on_error,
            )

            c.run_forever(ping_interval=30, **kwargs)
            time.sleep(5)
    except KeyboardInterrupt:
        logger.info("Kill command received, exiting!!")
