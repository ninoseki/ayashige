from app import dataclasses
from app.rules.abstract import AbstractRule


class Dot(AbstractRule):
    def __init__(self):
        self.name: str = "too_many_dots"

    def match(self, domain: dataclasses.Domain) -> dataclasses.Rule | None:
        count = domain.without_tld.count(".")
        if count >= 3:
            return dataclasses.Rule(name=self.name, score=count * 3)

        return None
