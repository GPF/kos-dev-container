FROM debian:bookworm-slim AS toolchain-unpack

RUN apt-get update && apt-get install -y --no-install-recommends unzip \
    && rm -rf /var/lib/apt/lists/*

COPY sh-elf.zip /tmp/sh-elf.zip
RUN unzip -q /tmp/sh-elf.zip -d /opt/toolchains/dc \
    && rm /tmp/sh-elf.zip

FROM debian:bookworm-slim

ENV DEBIAN_FRONTEND=noninteractive \
    KOS_BASE=/opt/toolchains/dc/kos \
    KOS_PORTS=/opt/toolchains/dc/kos-ports \
    KOS_CC_BASE=/opt/toolchains/dc/sh-elf \
    KOS_CC_PREFIX=sh-elf \
    DC_TOOLS_BASE=/opt/toolchains/dc/bin \
    PATH=/opt/toolchains/dc/sh-elf/bin:/opt/toolchains/dc/bin:$PATH

RUN apt-get update && apt-get install -y --no-install-recommends \
        bash bison build-essential ca-certificates cmake curl flex git make python3 \
        pkg-config unzip xz-utils \
    && rm -rf /var/lib/apt/lists/*

WORKDIR /opt/toolchains/dc
COPY --from=toolchain-unpack /opt/toolchains/dc/sh-elf/ /opt/toolchains/dc/sh-elf/
COPY entrypoint.sh /usr/local/bin/kos-container-entrypoint

ARG KOS_REPO=https://github.com/KallistiOS/KallistiOS.git
ARG KOS_REF=master
ARG KOS_PORTS_REPO=https://github.com/KallistiOS/kos-ports.git
ARG KOS_PORTS_REF=master

RUN git clone --depth 1 --branch "${KOS_REF}" "${KOS_REPO}" "${KOS_BASE}" \
    && git clone --depth 1 --branch "${KOS_PORTS_REF}" "${KOS_PORTS_REPO}" "${KOS_PORTS}"

RUN . "${KOS_BASE}/environ.sh" \
    && make -C "${KOS_BASE}" -j"$(nproc)"

RUN . "${KOS_BASE}/environ.sh" \
    && make -C "${KOS_PORTS}/sh4zam" install clean

ENTRYPOINT ["/usr/local/bin/kos-container-entrypoint"]
CMD ["bash", "-i"]
