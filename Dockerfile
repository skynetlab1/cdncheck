# Base
FROM golang:1.20.6-alpine AS builder

RUN apk add --no-cache git build-base gcc musl-dev
WORKDIR /app
COPY . /app
RUN go mod download
RUN go build ./cmd/cdncheck

FROM alpine:3.19.4
RUN apk -U upgrade --no-cache \
    && apk add --no-cache bind-tools ca-certificates
COPY --from=builder /app/cdncheck /usr/local/bin/

ENTRYPOINT ["cdncheck"]
