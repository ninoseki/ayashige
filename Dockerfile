# base
FROM python:3.11-slim-bookworm as base

WORKDIR /usr/src/app

COPY pyproject.toml poetry.lock ./

RUN pip install poetry==1.8.3 && \
	poetry config virtualenvs.create false && \
	poetry install --only main

# main
FROM python:3.11-slim-bookworm

COPY --from=base /usr/local/bin /usr/local/bin
COPY --from=base /usr/local/lib/python3.11/site-packages /usr/local/lib/python3.11/site-packages

WORKDIR /usr/src

COPY app ./app

