import pytest

from app import dataclasses
from app.rules import Dash


@pytest.mark.parametrize(
    "string,expected",
    [
        ("foo-example.com", False),
        ("foo-bar-example.com", False),
        ("foo-bar-not-good-bad.com", True),
    ],
)
def test_dash(string: str, expected: bool):
    domain = dataclasses.Domain(string)

    dash = Dash()
    rule = dash.match(domain)
    if expected:
        assert rule is not None
    else:
        assert rule is None
