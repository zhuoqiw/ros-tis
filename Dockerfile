# Build TIS deb package on ros:galactic
FROM ros:galactic AS base

# Clone TIS repo
RUN git clone -b v-tiscamera-0.14.0 https://github.com/TheImagingSource/tiscamera.git

# Install TIS dependencies
RUN sed -i 's?"sudo", "apt"?"apt-get"?g' tiscamera/scripts/dependency-manager \
    && export DEBIAN_FRONTEND=noninteractive \
    && ./tiscamera/scripts/dependency-manager install --yes --compilation --modules base,gstreamer,v4l2 \
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
FROM busybox:latest

# Copy created deb
COPY --from=base /build_package/tiscamera*.deb /tiscamera.deb

# Copy udev related files
COPY --from=base /tiscamera/data/uvc-extensions /setup/usr/share/theimagingsource/tiscamera/uvc-extension
COPY --from=base /build_uvc/data/udev/80-theimagingsource-cameras.rules /setup/etc/udev/rules.d/80-theimagingsource-cameras.rules
COPY --from=base /build_uvc/src/v4l2/libtcam-uvc-extension.so /setup/usr/lib/libtcam-uvc-extension.so
COPY --from=base /build_uvc/tools/tcam-uvc-extension-loader/tcam-uvc-extension-loader /setup/usr/bin/tcam-uvc-extension-loader
