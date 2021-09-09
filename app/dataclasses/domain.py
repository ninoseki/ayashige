import functools
import re
from dataclasses import dataclass
from typing import List, cast

import tld


@functools.lru_cache(maxsize=1024)
def get_tld(s: str) -> tld.Result:
    res = tld.get_tld(s, as_object=True, fix_protocol=True)
    return cast(tld.Result, res)


def remove_wildcard(fqdn: str) -> str:
    return fqdn.removeprefix("*.")


@dataclass
class Domain:
    fqdn: str

    def __post_init__(self):
        self.fqdn = remove_wildcard(self.fqdn)
        self._parsed = get_tld(self.fqdn)

    @property
    def tld(self) -> str:
        return self._parsed.tld

    @functools.cached_property
    def without_tld(self) -> str:
        if self._parsed.subdomain == "":
            return self._parsed.domain

        return f"{self._parsed.subdomain}.{self._parsed.domain}"

    @functools.cached_property
    def inner_words(self) -> List[str]:
        return re.split(r"\W+", self.without_tld)
