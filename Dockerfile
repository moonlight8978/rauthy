FROM gcr.io/distroless/cc-debian12:nonroot

ARG TARGETARCH

ARG TARGET_USER="10001:10001"

ENV MALLOC_CONF="abort_conf:true,narenas:8,tcache_max:4096,dirty_decay_ms:5000,muzzy_decay_ms:5000"

WORKDIR /app

COPY --chown=$TARGET_USER ./target/rauthy_$TARGETARCH ./rauthy
COPY --chown=$TARGET_USER ./config-local-test.toml ./config-local-test.toml

VOLUME ["/app/data", "/app/tls"]

USER 10001

CMD ["/app/rauthy"]
