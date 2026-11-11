
# Copyright 2020 Google LLC
#
# Licensed under the Apache License, Version 2.0

FROM python:3.10.8-slim@sha256:49749648f4426b31b20fca55ad854caa55ff59dc604f2f76b57d814e0a47c181 AS base

FROM base AS builder

# Install required packages
RUN apt-get clean \
    && rm -rf /var/lib/apt/lists/* \
    && apt-get update \
    && apt-get install -y --no-install-recommends \
        wget \
        g++ \
    && rm -rf /var/lib/apt/lists/*

# Download the grpc health probe
ENV GRPC_HEALTH_PROBE_VERSION=v0.4.18

RUN wget -qO/bin/grpc_health_probe \
    https://github.com/grpc-ecosystem/grpc-health-probe/releases/download/${GRPC_HEALTH_PROBE_VERSION}/grpc_health_probe-linux-amd64 \
    && chmod +x /bin/grpc_health_probe

# Install Python packages
COPY requirements.txt .
RUN pip install --no-cache-dir -r requirements.txt

FROM base AS without-grpc-health-probe-bin

# Enable unbuffered logging
ENV PYTHONUNBUFFERED=1

# Enable Profiler
ENV ENABLE_PROFILER=1

WORKDIR /email_server

# Copy Python packages from builder
COPY --from=builder /usr/local/lib/python3.10/ /usr/local/lib/python3.10/

# Add application files
COPY . .

EXPOSE 8080

ENTRYPOINT ["python", "email_server.py"]

FROM without-grpc-health-probe-bin

# Copy grpc health probe
COPY --from=builder /bin/grpc_health_probe /bin/grpc_health_probe
