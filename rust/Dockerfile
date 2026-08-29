# syntax=docker/dockerfile:1

# hadolint ignore=DL3006
FROM rust:1-slim@sha256:5c6f46a6e4472ab1ca7ba7d494e6677f2f219ebc02f32025d3986f057635ec9c AS builder

WORKDIR /app

COPY . ./

# Distroless has no shell/curl, so compile a tiny static healthcheck binary
RUN cargo build --locked --release && \
    printf '%s\n' \
        'use std::io::{Read, Write};' \
        'use std::net::TcpStream;' \
        'use std::process::exit;' \
        '' \
        'fn main() {' \
        '    match TcpStream::connect("127.0.0.1:3000") {' \
        '        Ok(mut stream) => {' \
        '            let _ = stream.write_all(b"GET / HTTP/1.1\r\nHost: localhost\r\nConnection: close\r\n\r\n");' \
        '            let mut buf = [0u8; 16];' \
        '            match stream.read(&mut buf) {' \
        '                Ok(n) if n > 0 && buf.starts_with(b"HTTP/1.1 2") => {}' \
        '                _ => exit(1),' \
        '            }' \
        '        }' \
        '        Err(_) => exit(1),' \
        '    }' \
        '}' \
        > /tmp/healthcheck.rs && \
    rustc -O /tmp/healthcheck.rs -o /healthcheck

# hadolint ignore=DL3006
FROM gcr.io/distroless/cc-debian12@sha256:e5d81ddde149641e2a9ba55be4545bc125c67de07508b03ba4c22e6eb0ded5aa AS runner

LABEL org.opencontainers.image.title="Rust Docker Example" \
      org.opencontainers.image.description="Rust application containerized with Docker" \
      org.opencontainers.image.source="https://github.com/emmanuelgautier/awesome-dockerfiles" \
      org.opencontainers.image.licenses="MIT"

ENV RUST_LOG="hello_world=debug,info"

COPY --from=builder /app/target/release/rust-dockerfiled-hello-world /
COPY --from=builder /healthcheck /healthcheck

EXPOSE 3000

HEALTHCHECK --interval=30s --timeout=3s --start-period=10s --retries=3 \
    CMD ["/healthcheck"]

ENTRYPOINT ["./rust-dockerfiled-hello-world"]
CMD ["./rust-dockerfiled-hello-world"]
