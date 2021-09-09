from dataclasses import dataclass
from typing import List, Optional


@dataclass
class Rule:
    name: str
    score: int
    notes: Optional[List[str]] = None
