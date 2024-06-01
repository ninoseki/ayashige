import pytest

from app import dataclasses
from app.rules import TLD


@pytest.mark.parametrize(
    "string,expected",
    [
        ("example.ga", True),
        ("example.com", False),
    ],
)
def test_dash(string: str, expected: bool):
    domain = dataclasses.Domain(fqdn=string)

    tld = TLD()
    rule = tld.match(domain)
    if expected:
        assert rule is not None
        assert rule.notes is not None
    else:
        assert rule is None
