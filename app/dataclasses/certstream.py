from typing import Any, Optional

from pydantic import BaseModel


class LeafCERT(BaseModel):
    all_domains: list[str]


class Source(BaseModel):
    name: str
    url: str


class Data(BaseModel):
    cert_index: int
    cert_link: str
    leaf_cert: LeafCERT
    seen: float
    source: Source
    update_type: str


class CertStreamUpdateMessage(BaseModel):
    data: Data
    message_type: str

    @classmethod
    def from_message(
        cls, message: dict[str, Any]
    ) -> Optional["CertStreamUpdateMessage"]:
        message_type = message.get("message_type")
        if message_type == "certificate_update":
            return cls.model_validate(message)

        return None
