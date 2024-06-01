import re
from typing import cast
from functools import lru_cache, cached_property

import tld
from pydantic import BaseModel, model_validator


@lru_cache(maxsize=1024)
def get_tld(s: str) -> tld.Result:
    res = tld.get_tld(s, as_object=True, fix_protocol=True)
    return cast(tld.Result, res)


def remove_wildcard(fqdn: str) -> str:
    return fqdn.removeprefix("*.")


class Domain(BaseModel):
    fqdn: str

    @model_validator(mode="after")
    def post_init(self):
        self.fqdn = remove_wildcard(self.fqdn)
        return self

    @cached_property
    def parsed(self) -> tld.Result:
        return get_tld(self.fqdn)

    @property
    def tld(self) -> str:
        return self.parsed.tld

    @cached_property
    def without_tld(self) -> str:
        if self.parsed.subdomain == "":
            return self.parsed.domain

        return f"{self.parsed.subdomain}.{self.parsed.domain}"

    @cached_property
    def inner_words(self) -> list[str]:
        return re.split(r"\W+", self.without_tld)
