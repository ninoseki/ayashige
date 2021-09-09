import gzip
from typing import Optional

import httpx

from app.core import settings


class SecurityTrails:
    def __init__(self):
        self.base_url = "https://api.securitytrails.com/v1"

    async def download_new_domain_feed(self, *, date: Optional[str] = None):
        url = self._url_for("/feeds/domains/registered")
        headers = {
            "accept-encoding": "application/gzip",
            "apikey": str(settings.SECURITYTRAILS_API_KEY),
        }

        params = {}
        if date is not None:
            params["date"] = date

        async with httpx.AsyncClient() as client:
            res = await client.get(url, headers=headers, params=params)
            res.raise_for_status()

        text = gzip.decompress(res.content).decode()
        lines = text.splitlines()
        return [line.strip() for line in lines]

    def _url_for(self, path: str):
        return self.base_url + path
