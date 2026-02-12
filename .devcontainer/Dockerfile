FROM ubuntu:24.04

WORKDIR /workspace

RUN apt-get update && apt-get install -y \
    # Build tools
    curl \
    git \
    ca-certificates \
    build-essential \
    libssl-dev \
    pkg-config \
    # Toolchains
    gcc-x86-64-linux-gnu \
    gcc-aarch64-linux-gnu \
    && rm -rf /var/lib/apt/lists/*

ENV PATH="/root/.local/bin:$PATH"

RUN curl https://mise.run | sh && \
    echo 'eval "$(mise activate bash)"' >> /root/.bashrc
COPY mise.toml /workspace/.mise.toml
RUN mise trust && mise install -y
