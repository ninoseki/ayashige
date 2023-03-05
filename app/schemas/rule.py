from .api_model import APIModel


class Rule(APIModel):
    name: str
    score: int
    notes: list[str] | None
