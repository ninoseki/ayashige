from app import dataclasses, schemas


def test_domain_conversion():
    dataclass_domain = dataclasses.DomainWithVerdiction(
        fqdn="bad-bad-bad-not-good.evil.example.com",
        source="dummy",
        updated_on="1970-01-01",
    )
    pydantic_domain = schemas.Domain.parse_obj(dataclass_domain.to_dict())
    assert pydantic_domain.fqdn == dataclass_domain.fqdn
