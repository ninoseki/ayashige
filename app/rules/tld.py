from app import dataclasses
from app.rules.abstract import AbstractRule

from .constants import SUSPICIOUS_TLDS


class TLD(AbstractRule):
    def __init__(self):
        self.name: str = "suspicious_tld"

    def match(self, domain: dataclasses.Domain) -> dataclasses.Rule | None:
        if domain.tld in SUSPICIOUS_TLDS:
            note = f"{domain.tld}:20"
            return dataclasses.Rule(name=self.name, score=20, notes=[note])

        return None
