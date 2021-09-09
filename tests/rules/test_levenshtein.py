import pytest

from app import dataclasses
from app.rules import LevenshteinDistance


@pytest.mark.parametrize(
    "string,expected",
    [
        ("netflixz.com", True),
        ("netflix.com", False),
        ("example.com", False),
    ],
)
def test_dash(string: str, expected: bool):
    domain = dataclasses.Domain(string)

    levenshtein = LevenshteinDistance()
    rule = levenshtein.match(domain)

    if expected:
        assert rule is not None
        assert rule.notes is not None
    else:
        assert rule is None
