FROM python:3.14 AS requirements-builder

ENV POETRY_HOME="/opt/poetry"
ENV POETRY_VERSION=1.6.1
ENV PATH="$POETRY_HOME/bin:$VENV_PATH/bin:$PATH"

SHELL ["/bin/bash", "-o", "pipefail", "-c"]
RUN curl -sSL https://install.python-poetry.org | POETRY_HOME=${POETRY_HOME} python3 - --version ${POETRY_VERSION}

WORKDIR /code

COPY ./poetry.lock ./pyproject.toml ./
RUN poetry export -f requirements.txt --output requirements.txt --without-hashes

FROM python:3.14-slim

WORKDIR /code

COPY --from=requirements-builder /code/requirements.txt ./
RUN pip install --no-cache-dir --upgrade -r requirements.txt

COPY ./app ./app

CMD ["uvicorn", "app.main:app", "--host", "0.0.0.0", "--port", "8000"]
