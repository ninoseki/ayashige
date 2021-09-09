import math
from typing import Optional

from app import dataclasses
from app.rules.abstract import AbstractRule


def calculate_entropy(string: str) -> float:
    prob = [float(string.count(c)) / len(string) for c in dict.fromkeys(list(string))]
    entropy = -sum(p * math.log(p) / math.log(2.0) for p in prob)
    return entropy


class Entropy(AbstractRule):
    def __init__(self):
        self.name: str = "entropy"

    def match(self, domain: dataclasses.Domain) -> Optional[dataclasses.Rule]:
        entropy = calculate_entropy(domain.without_tld)
        score = int(round(entropy) * 10)
        return dataclasses.Rule(name=self.name, score=score)
