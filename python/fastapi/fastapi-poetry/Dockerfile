FROM python:3.14-slim@sha256:cea0e6040540fb2b965b6e7fb5ffa00871e632eef63719f0ea54bca189ce14a6 AS requirements-builder

ENV POETRY_VERSION=2.4.1
ENV POETRY_PLUGIN_EXPORT_VERSION=1.9.0

RUN pip install --no-cache-dir "poetry==${POETRY_VERSION}" \
    && pip install --no-cache-dir "poetry-plugin-export==${POETRY_PLUGIN_EXPORT_VERSION}"

WORKDIR /code

COPY ./poetry.lock ./pyproject.toml ./
RUN poetry export -f requirements.txt --output requirements.txt --without-hashes

FROM python:3.14-slim@sha256:cea0e6040540fb2b965b6e7fb5ffa00871e632eef63719f0ea54bca189ce14a6

LABEL org.opencontainers.image.title="FastAPI (Poetry) Docker Example" \
      org.opencontainers.image.description="FastAPI application containerized with Docker" \
      org.opencontainers.image.source="https://github.com/emmanuelgautier/awesome-dockerfiles" \
      org.opencontainers.image.licenses="MIT"

WORKDIR /code

COPY --from=requirements-builder /code/requirements.txt ./
RUN pip install --no-cache-dir --upgrade -r requirements.txt

COPY ./app ./app

RUN apt-get update \
    && apt-get install -y --no-install-recommends curl=8.14.1-2+deb13u4 \
    && rm -rf /var/lib/apt/lists/* \
    && groupadd --gid 1000 app \
    && useradd --uid 1000 --gid app --no-create-home --shell /usr/sbin/nologin app \
    && chown -R app:app /code

USER app:app

EXPOSE 8000

HEALTHCHECK --interval=30s --timeout=3s --start-period=5s --retries=3 \
    CMD curl --fail http://localhost:8000/health || exit 1

CMD ["uvicorn", "app.main:app", "--host", "0.0.0.0", "--port", "8000"]
