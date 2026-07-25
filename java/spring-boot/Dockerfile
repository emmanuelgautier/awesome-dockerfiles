# syntax=docker/dockerfile:1

FROM maven:3.9-eclipse-temurin-25@sha256:7e461cec477077c1d9e50b13df8aef9018764410f4c4cd7c34803f10c4c99e4c AS builder

WORKDIR /app

# Cache dependencies in their own layer, invalidated only when the POM changes
COPY pom.xml ./
RUN --mount=type=cache,target=/root/.m2 mvn -B -ntp dependency:go-offline

COPY src ./src

RUN --mount=type=cache,target=/root/.m2 mvn -B -ntp -DskipTests package \
    && java -Djarmode=tools -jar target/app.jar extract --launcher \
        --layers dependencies,spring-boot-loader,snapshot-dependencies,application \
        --destination target/extracted

FROM eclipse-temurin:25-jre-jammy@sha256:b8ba5fca9d88b6ecc3a46c8e75b744f84aca9a9d08587901b5ab480baf641ab5 AS runner

LABEL org.opencontainers.image.title="Spring Boot Docker Example" \
      org.opencontainers.image.description="Spring Boot application containerized with Docker" \
      org.opencontainers.image.source="https://github.com/emmanuelgautier/awesome-dockerfiles" \
      org.opencontainers.image.licenses="MIT"

RUN apt-get update \
    && apt-get install -y --no-install-recommends curl=7.81.0-1ubuntu1.25 \
    && rm -rf /var/lib/apt/lists/* \
    && groupadd --gid 1000 spring \
    && useradd --uid 1000 --gid spring --no-create-home --shell /usr/sbin/nologin spring

WORKDIR /app

COPY --from=builder --chown=spring:spring /app/target/extracted/dependencies/ ./
COPY --from=builder --chown=spring:spring /app/target/extracted/spring-boot-loader/ ./
COPY --from=builder --chown=spring:spring /app/target/extracted/snapshot-dependencies/ ./
COPY --from=builder --chown=spring:spring /app/target/extracted/application/ ./

ENV JDK_JAVA_OPTIONS="-XX:MaxRAMPercentage=75.0 -XX:+ExitOnOutOfMemoryError" \
    SERVER_PORT=8080

EXPOSE 8080

USER spring:spring

HEALTHCHECK --interval=30s --timeout=3s --start-period=30s --retries=3 \
    CMD curl --fail http://localhost:8080/actuator/health || exit 1

ENTRYPOINT ["java", "org.springframework.boot.loader.launch.JarLauncher"]
