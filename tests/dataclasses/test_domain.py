import pytest

from app.dataclasses import Domain


@pytest.mark.parametrize(
    "string,expected",
    [
        ("*.example.com", "example.com"),
        ("example.com", "example.com"),
    ],
)
def test_remove_wildcard(string: str, expected: str):
    domain = Domain(fqdn=string)
    assert domain.fqdn == expected


@pytest.mark.parametrize(
    "string,expected",
    [
        ("example.com", "com"),
        ("example.ga", "ga"),
    ],
)
def test_tld(string: str, expected: str):
    domain = Domain(fqdn=string)
    assert domain.tld == expected


@pytest.mark.parametrize(
    "string,expected",
    [
        ("example.com", "example"),
        ("foo.example.com", "foo.example"),
        ("foo.bar.example.com", "foo.bar.example"),
    ],
)
def test_without_tld(string: str, expected: str):
    domain = Domain(fqdn=string)
    assert domain.without_tld == expected


@pytest.mark.parametrize(
    "string,expected",
    [
        ("example.com", ["example"]),
        ("foo.example.com", ["foo", "example"]),
        ("foo.bar.example.com", ["foo", "bar", "example"]),
        ("foo-bar-example.com", ["foo", "bar", "example"]),
    ],
)
def test_inner_words(string: str, expected: list[str]):
    domain = Domain(fqdn=string)
    assert domain.inner_words == expected
