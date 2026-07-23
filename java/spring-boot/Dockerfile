# syntax=docker/dockerfile:1

FROM maven:3.9-eclipse-temurin-21 AS builder

WORKDIR /app

# Cache dependencies in their own layer, invalidated only when the POM changes
COPY pom.xml ./
RUN --mount=type=cache,target=/root/.m2 mvn -B -ntp dependency:go-offline

COPY src ./src

RUN --mount=type=cache,target=/root/.m2 mvn -B -ntp -DskipTests package \
    && java -Djarmode=tools -jar target/app.jar extract --launcher \
        --layers dependencies,spring-boot-loader,snapshot-dependencies,application \
        --destination target/extracted

FROM eclipse-temurin:21-jre-jammy AS runner

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
