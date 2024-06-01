from app import dataclasses

from .abstract import AbstractRule
from .constants import HIGH_REPUTATION_DOMAINS
from .dash import Dash
from .dot import Dot
from .keyword import Keyword
from .levenshtein import LevenshteinDistance
from .tld import TLD

RULES: list[AbstractRule] = [
    Dash(),
    Dot(),
    Keyword(),
    LevenshteinDistance(),
    TLD(),
]


def has_high_reputation(domain: dataclasses.Domain) -> bool:
    for high_reputation_domain in HIGH_REPUTATION_DOMAINS:
        if domain.fqdn.endswith(f".{high_reputation_domain}"):
            return True

    return False


def match_rules(domain: dataclasses.Domain) -> list[dataclasses.Rule]:
    # skip matching if it has a high reputation
    if has_high_reputation(domain):
        return []

    matched_rules = [rule.match(domain) for rule in RULES]
    return [rule for rule in matched_rules if rule is not None]
