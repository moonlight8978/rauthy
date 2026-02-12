FROM busybox:stable AS volumes
RUN mkdir -p /app/data /app/tls

FROM gcr.io/distroless/cc-debian13:nonroot

ARG TARGETARCH

ARG TARGET_USER="10001:10001"

ENV MALLOC_CONF="abort_conf:true,narenas:8,tcache_max:4096,dirty_decay_ms:5000,muzzy_decay_ms:5000"

WORKDIR /app

COPY --from=volumes --chown=$TARGET_USER /app/data ./data
COPY --from=volumes --chown=$TARGET_USER /app/tls ./tls
COPY --chown=$TARGET_USER ./config-local-test.toml ./config-local-test.toml
COPY --chown=$TARGET_USER ./target/rauthy_$TARGETARCH ./rauthy

VOLUME ["/app/data", "/app/tls"]

USER $TARGET_USER

CMD ["/app/rauthy"]
