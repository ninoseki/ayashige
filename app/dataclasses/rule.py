from pydantic import BaseModel


class Rule(BaseModel):
    name: str
    score: int
    notes: list[str] | None = None
