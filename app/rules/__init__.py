from typing import TYPE_CHECKING, List, Optional, Type

from .abstract import AbstractRule
from .dash import Dash
from .dot import Dot
from .keyword import Keyword
from .levenshtein import LevenshteinDistance
from .tld import TLD

if TYPE_CHECKING:
    from app import dataclasses

RULES: List[Type[AbstractRule]] = [
    Dash(),
    Dot(),
    Keyword(),
    LevenshteinDistance(),
    TLD(),
]


def match_rules(domain: "dataclasses.Domain") -> List["dataclasses.Rule"]:
    matched_rules: List[Optional["dataclasses.Rule"]] = []
    for rule in RULES:
        matched_rules.append(rule.match(domain))

    return [rule for rule in matched_rules if rule is not None]
