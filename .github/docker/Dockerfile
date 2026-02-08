FROM alpine:3.19

RUN apk add --no-cache ca-certificates tzdata && \
    cp /usr/share/zoneinfo/America/Sao_Paulo /etc/localtime && \
    echo 'America/Sao_Paulo' > /etc/timezone

WORKDIR /app
COPY runner /usr/local/bin/runner

ENTRYPOINT ["/usr/local/bin/runner"]