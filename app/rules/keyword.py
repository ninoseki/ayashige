from typing import List, Optional

from app import dataclasses
from app.rules.abstract import AbstractRule

from .constants import SUSPICIOUS_KEYWORDS


class Keyword(AbstractRule):
    def __init__(self):
        self.name: str = "suspicious_keyword"

    def match(self, domain: dataclasses.Domain) -> Optional[dataclasses.Rule]:
        scores: List[int] = []
        matched_keywords: List[str] = []

        for keyword, score in SUSPICIOUS_KEYWORDS.items():
            if keyword in domain.inner_words:
                scores.append(score)
                matched_keywords.append(f"{keyword}:{score}")

        total_score = sum(scores)
        if total_score > 0:
            return dataclasses.Rule(
                name=self.name, score=total_score, notes=matched_keywords
            )

        return None
