# Spring Boot Dockerfile Example

## Description

This repository provides a Dockerfile example for containerizing a production-ready Spring Boot 3 application (Java 21).

The Dockerfile follows Spring Boot's recommended packaging approach:

- Multi-stage build: dependencies are resolved and cached in a separate layer from the application code, and the build stage (Maven + JDK) is discarded from the final image.
- Jar layer extraction (`-Djarmode=tools`) so the runtime image is composed of `dependencies`, `spring-boot-loader`, `snapshot-dependencies` and `application` layers. This maximizes Docker layer cache reuse: rebuilding after a code-only change only touches the `application` layer.
- Minimal JRE-only runtime image (`eclipse-temurin:21-jre-jammy`), not the full JDK.
- Runs as a dedicated non-root user.
- `HEALTHCHECK` backed by Spring Boot Actuator's `/actuator/health` endpoint.
- JVM tuned for containers via `JDK_JAVA_OPTIONS` (`MaxRAMPercentage`, `ExitOnOutOfMemoryError`).
- Graceful shutdown enabled (`server.shutdown: graceful`) so in-flight requests finish before the container stops.

## Getting Started

1. Copy the `Dockerfile`, `.dockerignore`, `pom.xml` and `src/` used in the Dockerfile in your application
2. Build the Docker image by running the following command:

```bash
docker build -t spring-boot-docker .
```

3. Once the image is built successfully, you can run a container using the following command:

```bash
docker run -p 8080:8080 spring-boot-docker
```

4. Test your application container

```bash
curl http://localhost:8080/
curl http://localhost:8080/actuator/health
```

## Contributing

Contributions to this Dockerfile example are welcome! If you have any improvements or suggestions, feel free to submit a pull request.

Please ensure that your changes align with the best practices and conventions outlined in the Docker and language/framework documentation.

## Disclaimer

The Dockerfile example provided in this repository is for educational and reference purposes. It is important to review and adapt it to meet the specific security and performance requirements of your case before using it in a production environment.
