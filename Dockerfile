FROM golang:1.23.5
LABEL maintainer="Victor Castell <0x@vcastellm.xyz>"
EXPOSE 8080 8946
RUN mkdir -p /app
WORKDIR /app
ENV GO111MODULE=on
ENV GODEBUG=netdns=go
# Leverage build cache by copying go.mod and go.sum first
COPY go.mod go.sum ./
RUN go mod download
RUN go mod verify
RUN go mod download
# Copy the rest of the source code
COPY . .
RUN go install ./...
CMD ["dkron", "agent", "--server", "--log-level=info", "--bootstrap-expect=3", "--retry-join=dkron-1", "--retry-join=dkron-2", "--retry-join=dkron-3"]
