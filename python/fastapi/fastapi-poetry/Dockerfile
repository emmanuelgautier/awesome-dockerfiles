FROM python:3.13 AS requirements-builder

ENV POETRY_VERSION=2.4.1
ENV POETRY_PLUGIN_EXPORT_VERSION=1.9.0

RUN pip install --no-cache-dir "poetry==${POETRY_VERSION}" \
    && pip install --no-cache-dir "poetry-plugin-export==${POETRY_PLUGIN_EXPORT_VERSION}"

WORKDIR /code

COPY ./poetry.lock ./pyproject.toml ./
RUN poetry export -f requirements.txt --output requirements.txt --without-hashes

FROM python:3.13-slim

WORKDIR /code

COPY --from=requirements-builder /code/requirements.txt ./
RUN pip install --no-cache-dir --upgrade -r requirements.txt

COPY ./app ./app

EXPOSE 8000

CMD ["uvicorn", "app.main:app", "--host", "0.0.0.0", "--port", "8000"]
