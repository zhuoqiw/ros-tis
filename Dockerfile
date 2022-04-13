# Build TIS deb package on ros:galactic
FROM ros:galactic AS base

# Clone TIS repo
RUN git clone -b v-tiscamera-0.14.0 https://github.com/TheImagingSource/tiscamera.git

# Remove extra dependencies
# COPY ubuntu_2004.dep tiscamera/dependencies

# Install TIS dependencies
RUN sed -i 's?"sudo", "apt"?"apt-get"?g' tiscamera/scripts/dependency-manager \
    && export DEBIAN_FRONTEND=noninteractive \
    && ./tiscamera/scripts/dependency-manager install -y \
    && rm -rf /var/lib/apt/lists/*

# Config, build, package
RUN cmake \
    -D BUILD_TOOLS:BOOL=OFF \
    -S tiscamera \
    -B build_package \
    && cmake --build build_package --target package

RUN cmake \
    -D TCAM_BUILD_UVC_EXTENSION_LOADER_ONLY:BOOL=ON \
    -S tiscamera \
    -B build_uvc \
    && cmake --build build_uvc

# Use busybox as container
# FROM busybox:latest

# Copy created deb
# COPY --from=base /tiscamera/build/tiscamera*.deb /tiscamera.deb
