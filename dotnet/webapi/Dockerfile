# syntax=docker/dockerfile:1

FROM mcr.microsoft.com/dotnet/sdk:10.0@sha256:bef136a371963aaa46ec97882845ef6f54dec15728bb4b128b1c2a400ffbc9b4 AS builder

WORKDIR /src

# Cache dependencies in their own layer, invalidated only when the csproj changes
COPY WebApi.csproj ./
RUN --mount=type=cache,target=/root/.nuget/packages \
    dotnet restore WebApi.csproj

COPY . .

RUN --mount=type=cache,target=/root/.nuget/packages \
    dotnet publish WebApi.csproj -c Release -o /app/publish --no-restore

FROM mcr.microsoft.com/dotnet/aspnet:10.0-noble@sha256:12b1135f5f8b3c0a214f2a680ff2033dff4f684f445d6c697d9524ceeb303586 AS runner

LABEL org.opencontainers.image.title=".NET Web API Docker Example" \
      org.opencontainers.image.description=".NET Web API application containerized with Docker" \
      org.opencontainers.image.source="https://github.com/emmanuelgautier/awesome-dockerfiles" \
      org.opencontainers.image.licenses="MIT"

RUN apt-get update \
    && apt-get install -y --no-install-recommends curl=8.5.0-2ubuntu10.11 \
    && rm -rf /var/lib/apt/lists/*

WORKDIR /app

COPY --from=builder --chown=app:app /app/publish ./

ENV ASPNETCORE_HTTP_PORTS=8080 \
    DOTNET_RUNNING_IN_CONTAINER=true \
    DOTNET_EnableDiagnostics=0

EXPOSE 8080

USER app:app

HEALTHCHECK --interval=30s --timeout=3s --start-period=10s --retries=3 \
    CMD curl --fail http://localhost:8080/health || exit 1

ENTRYPOINT ["dotnet", "WebApi.dll"]
