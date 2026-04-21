# syntax=docker/dockerfile:1
ARG PYVER=3.12.9
FROM python:${PYVER}-slim-bookworm AS builder

RUN apt-get update && apt-get install -y --no-install-recommends \
    build-essential patchelf libssl-dev libexpat1-dev \
    && rm -rf /var/lib/apt/lists/*

RUN pip3 install setuptools cx_Freeze patchelf-wrapper

COPY . .

# Install Curator locally
RUN pip3 install .

# Build (or rather Freeze) Curator
RUN cxfreeze build

# Rename 'build/exe.{system().lower()}-{machine()}-{MAJOR}.{MINOR}' to curator_build
RUN python3 post4docker.py

### End `builder` segment

### Copy frozen binary to the container that will actually be published
FROM debian:bookworm-slim
RUN apt-get update && apt-get install -y --no-install-recommends \
    libssl3 ca-certificates libexpat1 \
    && rm -rf /var/lib/apt/lists/*

# The path `curator_build` is from `builder` and `post4docker.py`
COPY --from=builder curator_build /curator/
RUN mkdir /.curator

USER nobody:nogroup
ENV LD_LIBRARY_PATH=/curator/lib:$LD_LIBRARY_PATH
ENTRYPOINT ["/curator/curator"]
