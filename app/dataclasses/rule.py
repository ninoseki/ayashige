from dataclasses import dataclass
from typing import Optional


@dataclass
class Rule:
    name: str
    score: int
    notes: Optional[list[str]] = None
