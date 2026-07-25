# Python Flask Dockerfile Example

## Description

This repository provides a production-ready Dockerfile example for containerizing a Python Flask application.

The Dockerfile follows Python container best practices:

- Multi-stage build: dependencies are installed into a virtual environment in a `builder` stage, keeping build tools out of the final image.
- Pip packages are cached with a build cache mount (`--mount=type=cache,target=/root/.cache/pip`), so rebuilds only download changed dependencies.
- Minimal `python:3.13-slim` base image for both stages.
- Runs as a dedicated non-root user.
- Served with `gunicorn` instead of the Flask development server.
- `HEALTHCHECK` backed by a `/health` endpoint.
- `PYTHONDONTWRITEBYTECODE` and `PYTHONUNBUFFERED` set to avoid stray `.pyc` files and to stream logs immediately.

## Getting Started

1. Copy the `Dockerfile`, `.dockerignore`, `requirements.txt` and `app/` folder into your Flask application
2. Build the Docker image by running the following command:

```bash
docker build -t flask-docker .
```

3. Once the image is built successfully, you can run a container using the following command:

```bash
docker run -p 8000:8000 flask-docker
```

4. Test your application container

```bash
curl http://localhost:8000/
curl http://localhost:8000/health
```

## Contributing

Contributions to this Dockerfile example are welcome! If you have any improvements or suggestions, feel free to submit a pull request.

Please ensure that your changes align with the best practices and conventions outlined in the Docker and Flask documentation.

## Disclaimer

The Dockerfile example provided in this repository is for educational and reference purposes. It is important to review and adapt it to meet the specific security and performance requirements of your case before using it in a production environment.
