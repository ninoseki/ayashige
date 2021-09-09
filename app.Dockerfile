FROM python:3.9-alpine3.14

WORKDIR /ayashige

RUN apk --no-cache add build-base gcc musl-dev python3-dev libffi-dev openssl-dev cargo

COPY pyproject.toml poetry.lock ./

RUN pip install poetry && \
	poetry config virtualenvs.create false && \
	poetry install --no-dev

COPY app ./app

ENV PORT 8000

EXPOSE $PORT

CMD uvicorn --host 0.0.0.0 --port $PORT app.main:app
