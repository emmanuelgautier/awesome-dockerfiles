# syntax=docker/dockerfile:1

FROM golang:1.26@sha256:3aff6657219a4d9c14e27fb1d8976c49c29fddb70ba835014f477e1c70636647 AS builder

WORKDIR /app

COPY go.mod go.sum ./
RUN go mod download

COPY . ./

# Distroless has no shell/curl, so compile a tiny static healthcheck binary
RUN CGO_ENABLED=0 GOOS=linux GO111MODULE=on go build -o /docker-go-server . && \
    printf '%s\n' \
        'package main' \
        '' \
        'import (' \
        '    "net/http"' \
        '    "os"' \
        ')' \
        '' \
        'func main() {' \
        '    resp, err := http.Get("http://localhost:8080/")' \
        '    if err != nil || resp.StatusCode >= 400 {' \
        '        os.Exit(1)' \
        '    }' \
        '}' \
        > /tmp/healthcheck.go && \
    CGO_ENABLED=0 GOOS=linux go build -o /healthcheck /tmp/healthcheck.go

FROM gcr.io/distroless/static-debian12:nonroot@sha256:afa5c872c891853ca7fcf1f12c3edb23f7eeef36189728842dd51042ff57f7ab AS runner

LABEL org.opencontainers.image.title="Go Docker Example" \
      org.opencontainers.image.description="Go application containerized with Docker" \
      org.opencontainers.image.source="https://github.com/emmanuelgautier/awesome-dockerfiles" \
      org.opencontainers.image.licenses="MIT"

WORKDIR /

COPY --from=builder --chown=nonroot:nonroot /docker-go-server /usr/bin/docker-go-server
COPY --from=builder --chown=nonroot:nonroot /healthcheck /usr/bin/healthcheck

EXPOSE 8080

USER nonroot:nonroot

HEALTHCHECK --interval=30s --timeout=3s --start-period=10s --retries=3 \
    CMD ["/usr/bin/healthcheck"]

ENTRYPOINT ["docker-go-server"]
CMD ["docker-go-server"]
