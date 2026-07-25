# Python Django Dockerfile Example

## Description

This repository provides a production-ready Dockerfile example for containerizing a Python Django application.

The Dockerfile follows Python and Django container best practices:

- Multi-stage build: dependencies are installed into a virtual environment and static files are collected in a `builder` stage, keeping build tools and source-only artifacts out of the final image.
- Pip packages are cached with a build cache mount (`--mount=type=cache,target=/root/.cache/pip`), so rebuilds only download changed dependencies.
- Minimal `python:3.13-slim` base image for both stages.
- Runs as a dedicated non-root user.
- Served with `gunicorn` instead of the Django development server.
- Static files served directly by the app via `whitenoise`, with `collectstatic` run at build time.
- `HEALTHCHECK` backed by a `/health` endpoint.
- `PYTHONDONTWRITEBYTECODE` and `PYTHONUNBUFFERED` set to avoid stray `.pyc` files and to stream logs immediately.
- `SECRET_KEY`, `DEBUG` and `ALLOWED_HOSTS` are read from environment variables, keeping secrets and per-environment settings out of the image.

## Getting Started

1. Copy the `Dockerfile`, `.dockerignore`, `requirements.txt` and `app/` folder into your Django application
2. Build the Docker image by running the following command:

```bash
docker build -t django-docker .
```

3. Once the image is built successfully, you can run a container using the following command:

```bash
docker run -p 8000:8000 \
  -e SECRET_KEY=change-me \
  -e ALLOWED_HOSTS=localhost \
  django-docker
```

4. Test your application container

```bash
curl http://localhost:8000/
curl http://localhost:8000/health
```

## Notes

- Run database migrations (`python manage.py migrate`) as a separate step or job outside of the image `CMD`, e.g. as a release step in your deployment pipeline.
- Always set a strong, unique `SECRET_KEY` and an explicit `ALLOWED_HOSTS` via environment variables in production.

## Contributing

Contributions to this Dockerfile example are welcome! If you have any improvements or suggestions, feel free to submit a pull request.

Please ensure that your changes align with the best practices and conventions outlined in the Docker and Django documentation.

## Disclaimer

The Dockerfile example provided in this repository is for educational and reference purposes. It is important to review and adapt it to meet the specific security and performance requirements of your case before using it in a production environment.
