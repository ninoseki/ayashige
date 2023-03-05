from dataclasses import dataclass


@dataclass
class Rule:
    name: str
    score: int
    notes: list[str] | None = None
