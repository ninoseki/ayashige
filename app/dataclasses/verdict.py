from functools import cached_property
from .rule import Rule

from .domain import Domain
from app.rules import match_rules


class DomainWithVerdict(Domain):
    source: str
    updated_on: str

    @cached_property
    def matched_rules(self) -> list[Rule]:
        return match_rules(self)

    @cached_property
    def score(self) -> int:
        scores = [rule.score for rule in self.matched_rules]
        return sum(scores)

    @cached_property
    def is_suspicious(self) -> bool:
        return self.score > 80

    def to_dict(self):
        matched_rules_in_dict = [rule.model_dump() for rule in self.matched_rules]
        return {
            "fqdn": self.fqdn,
            "source": self.source,
            "updated_on": self.updated_on,
            "score": self.score,
            "matched_rules": matched_rules_in_dict,
        }
