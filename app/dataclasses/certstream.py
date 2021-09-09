from dataclasses import dataclass
from typing import Any, Dict, List, Optional

from dataclasses_json import DataClassJsonMixin


@dataclass
class LeafCERT:
    all_domains: List[str]


@dataclass
class Source:
    name: str
    url: str


@dataclass
class Data:
    cert_index: int
    cert_link: str
    leaf_cert: LeafCERT
    seen: float
    source: Source
    update_type: str


@dataclass
class CertStreamUpdateMessage(DataClassJsonMixin):
    data: Data
    message_type: str

    @classmethod
    def from_message(
        cls, message: Dict[str, Any]
    ) -> Optional["CertStreamUpdateMessage"]:
        message_type = message.get("message_type")
        if message_type == "certificate_update":
            return cls.from_dict(message)

        return None
