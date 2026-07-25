# .NET Web API Dockerfile Example

## Description

This repository provides a Dockerfile example for containerizing a production-ready ASP.NET Core Web API (.NET 10).

The Dockerfile follows .NET's recommended container practices:

- Multi-stage build: the SDK (used for restore/publish) is discarded from the final image, keeping only the smaller ASP.NET Core runtime.
- Dependencies are restored in their own layer, invalidated only when the `.csproj` changes, and NuGet packages are cached with a build cache mount.
- `dotnet publish` produces a trimmed, Release-configuration output copied into the runtime image.
- Minimal ASP.NET Core runtime image (`mcr.microsoft.com/dotnet/aspnet:10.0-noble`), not the full SDK.
- Runs as a dedicated non-root user.
- `HEALTHCHECK` backed by a `/health` endpoint.
- Diagnostics (EventPipe/dumps) disabled in the runtime image via `DOTNET_EnableDiagnostics=0`.
- `InvariantGlobalization` enabled to shrink the published output; drop it if you need ICU-backed culture-specific formatting.
- ASP.NET Core listens on port 8080 (unprivileged) via `ASPNETCORE_HTTP_PORTS`, and handles `SIGTERM` gracefully by default so in-flight requests finish before the container stops.

## Getting Started

1. Copy the `Dockerfile`, `.dockerignore`, `WebApi.csproj`, `Program.cs`, `appsettings*.json` used in the Dockerfile in your application
2. Build the Docker image by running the following command:

```bash
docker build -t dotnet-webapi-docker .
```

3. Once the image is built successfully, you can run a container using the following command:

```bash
docker run -p 8080:8080 dotnet-webapi-docker
```

4. Test your application container

```bash
curl http://localhost:8080/
curl http://localhost:8080/health
```

## Contributing

Contributions to this Dockerfile example are welcome! If you have any improvements or suggestions, feel free to submit a pull request.

Please ensure that your changes align with the best practices and conventions outlined in the Docker and language/framework documentation.

## Disclaimer

The Dockerfile example provided in this repository is for educational and reference purposes. It is important to review and adapt it to meet the specific security and performance requirements of your case before using it in a production environment.
