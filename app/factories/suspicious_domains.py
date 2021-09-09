from typing import List, Optional

from app import dataclasses
from app.services.securitytrails import SecurityTrails
from app.utils import get_today_in_isoformat


class SuspiciousDomainsFactory:
    @classmethod
    def from_list(
        cls, domains: List[str], source: str, *, updated_on: Optional[str] = None
    ) -> List[dataclasses.DomainWithVerdiction]:
        if updated_on is None:
            updated_on = get_today_in_isoformat()

        suspicious_domains: List[dataclasses.DomainWithVerdiction] = []
        for new_domain in domains:
            domain = dataclasses.DomainWithVerdiction(
                fqdn=new_domain, source=source, updated_on=updated_on
            )
            if domain.is_suspicious:
                suspicious_domains.append(domain)

        return suspicious_domains

    @classmethod
    async def from_security_trails(cls) -> List[dataclasses.DomainWithVerdiction]:
        st = SecurityTrails()
        date = get_today_in_isoformat()
        new_domains = await st.download_new_domain_feed(date=date)

        return cls.from_list(new_domains, "SecurityTrails", updated_on=date)