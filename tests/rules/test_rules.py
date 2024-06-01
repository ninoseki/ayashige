import pytest

from app import dataclasses
from app.rules import match_rules


def find_rule_by_name(
    rules: list[dataclasses.Rule], name: str
) -> dataclasses.Rule | None:
    for rule in rules:
        if rule.name == name:
            return rule

    return None


def test_match_rules():
    domain = dataclasses.Domain(
        fqdn="apps-secure1-verify-information-foo-bar.apps.secure1.netfliz.verify.information.foo.bar.example.ga"
    )
    rules = match_rules(domain)

    assert find_rule_by_name(rules, "too_many_dots") is not None
    assert find_rule_by_name(rules, "too_many_dashes") is not None
    assert find_rule_by_name(rules, "suspicious_tld") is not None
    assert find_rule_by_name(rules, "suspicious_keyword") is not None
    assert (
        find_rule_by_name(rules, "suspicious_keyword_levenshtein_distance") is not None
    )


@pytest.mark.parametrize(
    "string",
    [
        "ab-pricing-console-eu-dub.dub.proxy.amazon.com",
        "ab-pricing-console-eu-dub.dub.proxy.cas.ms",
    ],
)
def test_match_rules_with_high_reputation_domain(string: str):
    domain = dataclasses.Domain(fqdn=string)
    rules = match_rules(domain)
    assert len(rules) == 0
