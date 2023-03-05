from app import dataclasses
from app.rules.abstract import AbstractRule


class Dash(AbstractRule):
    def __init__(self):
        self.name: str = "too_many_dashes"

    def match(self, domain: "dataclasses.Domain") -> dataclasses.Rule | None:
        if "xn--" in domain.fqdn:
            return None

        count = domain.without_tld.count("-")
        if count >= 4:
            return dataclasses.Rule(name=self.name, score=count * 3)

        return None
