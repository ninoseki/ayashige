import pytest

from app import dataclasses
from app.rules import Dot


@pytest.mark.parametrize(
    "string,expected",
    [
        ("foo.example.com", False),
        ("foo.bar.example.com", False),
        ("foo.bar.not.good.bad.com", True),
    ],
)
def test_dash(string: str, expected: bool):
    domain = dataclasses.Domain(fqdn=string)

    dot = Dot()
    rule = dot.match(domain)
    if expected:
        assert rule is not None
    else:
        assert rule is None
