from humps import camelize
from pydantic import BaseModel


class APIModel(BaseModel):
    class Config:
        orm_mode = True
        alias_generator = camelize
        allow_population_by_field_name = True
