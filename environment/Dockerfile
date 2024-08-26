# hash:sha256:5446423f1d181626fba2a0c925791437f4faa8873b9f804f1df4ecfa1012a8b3
FROM registry.apps.codeocean.com/codeocean/mambaforge3:22.11.1-4-ubuntu22.04

ARG DEBIAN_FRONTEND=noninteractive

ARG GIT_ASKPASS
ARG GIT_ACCESS_TOKEN
COPY git-askpass /

RUN apt-get update \
    && apt-get install -y --no-install-recommends \
        ca-certificates=20211016ubuntu0.22.04.1 \
        git=1:2.34.1-1ubuntu1.8 \
        samtools=1.13-4 \
        wget=1.21.2-2ubuntu1 \
    && rm -rf /var/lib/apt/lists/*

RUN pip install -U --no-cache-dir \
    code-ocean-aux-tools==1.1.3

COPY postInstall /
RUN /postInstall
