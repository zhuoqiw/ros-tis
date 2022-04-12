# Build TIS deb package on ros:galactic
FROM ros:galactic AS base

# Clone TIS repo
RUN git clone -b v-tiscamera-0.14.0 https://github.com/TheImagingSource/tiscamera.git

# Install TIS dependencies
RUN sed -i 's?"sudo", "apt"?"apt-get"?g' tiscamera/scripts/dependency-manager \
    && export DEBIAN_FRONTEND=noninteractive \
    && ./tiscamera/scripts/dependency-manager install -y

# Config, build
RUN cmake \
    -S tiscamera \
    -B tiscamera/build \
    && cmake --build tiscamera/build --target package

# Use busybox as container
FROM busybox:latest

# Copy created deb
COPY --from=base /tiscamera/build/tiscamera*.deb /tiscamera.deb
