from typing import List, Optional

from app import dataclasses
from app.rules import match_rules


def find_rule_by_name(
    rules: List[dataclasses.Rule], name: str
) -> Optional[dataclasses.Rule]:
    for rule in rules:
        if rule.name == name:
            return rule

    return None


def test_match_rules():
    domain = dataclasses.Domain(
        "apps-secure1-verify-information-foo-bar.apps.secure1.netfliz.verify.information.foo.bar.example.ga"
    )
    rules = match_rules(domain)

    assert find_rule_by_name(rules, "too_many_dots") is not None
    assert find_rule_by_name(rules, "too_many_dashes") is not None
    assert find_rule_by_name(rules, "suspicious_tld") is not None
    assert find_rule_by_name(rules, "suspicious_keyword") is not None
    assert (
        find_rule_by_name(rules, "suspicious_keyword_levenshtein_distance") is not None
    )


def test_match_rules_with_high_reputation_domain():
    domain = dataclasses.Domain(
        # it has many dashes but it has high reputation (official amazon domain)
        "ab-pricing-console-eu-dub.dub.proxy.amazon.com"
    )
    rules = match_rules(domain)
    assert len(rules) == 0
