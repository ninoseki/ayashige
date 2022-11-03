from typing import Optional

from .api_model import APIModel


class Rule(APIModel):
    name: str
    score: int
    notes: Optional[list[str]]
