import functools
from dataclasses import asdict, dataclass
from typing import List

from app.rules import match_rules

from .domain import Domain
from .rule import Rule


@dataclass
class DomainWithVerdiction(Domain):
    source: str
    updated_on: str

    @functools.cached_property
    def matched_rules(self) -> List[Rule]:
        return match_rules(self)

    @functools.cached_property
    def score(self) -> int:
        scores = [rule.score for rule in self.matched_rules]
        return sum(scores)

    @functools.cached_property
    def is_suspicious(self) -> bool:
        return self.score > 80

    def to_dict(self):
        matched_rules_in_dict = [asdict(rule) for rule in self.matched_rules]
        return {
            "fqdn": self.fqdn,
            "source": self.source,
            "updated_on": self.updated_on,
            "score": self.score,
            "matched_rules": matched_rules_in_dict,
        }
