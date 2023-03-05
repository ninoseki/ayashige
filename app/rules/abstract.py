import abc

from app import dataclasses


class AbstractRule(abc.ABC):
    @abc.abstractmethod
    def match(self, domain: dataclasses.Domain) -> dataclasses.Rule | None:
        raise NotImplementedError()
