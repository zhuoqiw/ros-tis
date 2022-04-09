# Build TIS deb package on ubuntu:20.04
FROM ubuntu:20.04 AS base

# Install python3 and git
RUN apt-get update && export DEBIAN_FRONTEND=noninteractive \
    && apt-get -y install --no-install-recommends \
    ca-certificates \
    lsb-release \
    python3 \
    git

# Clone TIS repo
RUN git clone -b v-tiscamera-0.14.0 https://github.com/TheImagingSource/tiscamera.git

# Install TIS dependencies
RUN sed -i 's?"sudo", "apt"?"sudo", "apt-get"?g' tiscamera/scripts/dependency-manager \
    && export DEBIAN_FRONTEND=noninteractive \
    && ./tiscamera/scripts/dependency-manager install -y

# Config, build, install TIS
RUN cmake \
    -S tiscamera \
    -B tiscamera/build \
    && cmake --build tiscamera/build --target package

FROM busybox:latest

COPY --from=base /tiscamera/build/tiscamera*.deb /tiscamera.deb