from datetime import date
from typing import List

from .api_model import APIModel
from .rule import Rule


class Domain(APIModel):
    fqdn: str
    source: str
    updated_on: date
    score: int
    matched_rules: List[Rule]
