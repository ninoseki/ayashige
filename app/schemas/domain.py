from datetime import date

from .api_model import APIModel
from .rule import Rule


class Domain(APIModel):
    fqdn: str
    source: str
    updated_on: date
    score: int
    matched_rules: list[Rule]
