FROM python:3.11-alpine

WORKDIR /ayashige

RUN apk --no-cache add build-base gcc musl-dev python3-dev libffi-dev openssl-dev cargo

COPY pyproject.toml poetry.lock ./

RUN pip install poetry==1.4.0 && \
	poetry config virtualenvs.create false && \
	poetry install --no-dev

COPY app ./app

CMD arq app.arq.worker.ArqWorkerSettings
