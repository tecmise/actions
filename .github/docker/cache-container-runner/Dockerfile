FROM golang:1.25-alpine as build

ENV GOBIN /usr/local/go/bin
ENV PATH /go/bin:$PATH
ENV GO111MODULE on
ENV GOPROXY direct
ENV GOPRIVATE=github.com/tecmise/*
ENV GOSUMDB off

RUN apk update && \
   apk --no-cache upgrade && \
   apk add --no-cache tzdata gcc musl-dev git make bash && \
   cp /usr/share/zoneinfo/Brazil/East /etc/localtime && \
   echo 'Brazil/East' > /etc/timezone && \
   rm -rf /var/cache/apk/*

WORKDIR /app

COPY . .

ARG TOKEN

ENV TOKEN=${TOKEN}

RUN rm -rf go.sum
RUN git config --global url."https://${TOKEN}:x-oauth-basic@github.com/".insteadOf "https://github.com/"

RUN go clean --modcache
RUN go mod tidy
RUN go mod download
RUN go mod verify
RUN go mod vendor

