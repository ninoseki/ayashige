from Levenshtein import distance

from app import dataclasses
from app.rules.abstract import AbstractRule

from .constants import SUSPICIOUS_KEYWORDS

SUSPICIOUS_KEYWORDS_FOR_LEVENSHTEIN_DISTANCE: list[str] = []
for keyword, score in SUSPICIOUS_KEYWORDS.items():
    if score >= 70:
        SUSPICIOUS_KEYWORDS_FOR_LEVENSHTEIN_DISTANCE.append(keyword)

IGNORE_KEYWORDS: list[str] = ["email", "mail", "cloud"]


class LevenshteinDistance(AbstractRule):
    def __init__(self):
        self.name: str = "suspicious_keyword_levenshtein_distance"

    def match(self, domain: dataclasses.Domain) -> dataclasses.Rule | None:
        score = 0
        matched_keywords: list[str] = []

        for keyword in SUSPICIOUS_KEYWORDS_FOR_LEVENSHTEIN_DISTANCE:
            for word in domain.inner_words:
                if word in IGNORE_KEYWORDS:
                    continue

                if distance(keyword, word) == 1:
                    score += 70
                    matched_keywords.append(f"{keyword}:{word}:70")

        if score > 0:
            return dataclasses.Rule(name=self.name, score=score, notes=matched_keywords)

        return None
