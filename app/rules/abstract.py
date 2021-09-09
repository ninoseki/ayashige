import abc
from typing import Optional

from app import dataclasses


class AbstractRule(abc.ABC):
    @abc.abstractmethod
    def match(self, domain: dataclasses.Domain) -> Optional[dataclasses.Rule]:
        raise NotImplementedError()
