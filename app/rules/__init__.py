from typing import List, Optional, Type

from app import dataclasses

from .abstract import AbstractRule
from .constants import ALEXA_TOP_DOMAINS
from .dash import Dash
from .dot import Dot
from .keyword import Keyword
from .levenshtein import LevenshteinDistance
from .tld import TLD

RULES: List[Type[AbstractRule]] = [
    Dash(),
    Dot(),
    Keyword(),
    LevenshteinDistance(),
    TLD(),
]


def has_high_reputation(domain: dataclasses.Domain) -> bool:
    for top_domain in ALEXA_TOP_DOMAINS:
        if domain.fqdn.endswith(f".{top_domain}"):
            return True

    return False


def match_rules(domain: dataclasses.Domain) -> List[dataclasses.Rule]:
    # skip matching if it has a high reputation
    if has_high_reputation(domain):
        return []

    matched_rules: List[Optional[dataclasses.Rule]] = []
    for rule in RULES:
        matched_rules.append(rule.match(domain))

    return [rule for rule in matched_rules if rule is not None]
