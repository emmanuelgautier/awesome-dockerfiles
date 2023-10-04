FROM golang:1.21 AS builder

WORKDIR /app

COPY go.mod go.sum ./
RUN go mod download

COPY . ./

RUN CGO_ENABLED=0 GOOS=linux GO111MODULE=on go build -o /docker-go-server .

FROM gcr.io/distroless/static-debian11:nonroot AS runner

WORKDIR /

COPY --from=builder --chown=nonroot:nonroot /docker-go-server /usr/bin/docker-go-server

EXPOSE 8080

USER nonroot:nonroot

ENTRYPOINT ["docker-go-server"]
CMD ["docker-go-server"]
