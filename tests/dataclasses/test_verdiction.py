import pytest

from app.dataclasses import DomainWithVerdiction


@pytest.mark.parametrize(
    "string,expected",
    [
        ("example.com", False),
        (
            "apps-secure1-verify-information-foo-bar.apps.secure1.netfliz.verify.information.foo.bar.example.ga",
            True,
        ),
    ],
)
def test_is_suspicious(string: str, expected: bool):
    domain = DomainWithVerdiction(fqdn=string, source="dummy", updated_on="dummy")
    assert domain.is_suspicious is expected
