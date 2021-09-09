import pytest

from app import dataclasses
from app.rules import Keyword


@pytest.mark.parametrize(
    "string,expected",
    [
        ("verify.example.com", True),
        ("example.com", False),
    ],
)
def test_dash(string: str, expected: bool):
    domain = dataclasses.Domain(string)

    keyword = Keyword()
    rule = keyword.match(domain)

    if expected:
        assert rule is not None
        assert rule.notes is not None
    else:
        assert rule is None
