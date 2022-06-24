# ROS code name: galactic, humble
ARG ROS_DISTRO

# Build TIS deb package on ros:galactic
FROM ros:${ROS_DISTRO} AS base

# Clone TIS repo
RUN git clone -b v-tiscamera-1.0.0 https://github.com/TheImagingSource/tiscamera.git

# Overwrite dependencies, remove good, bad, ugly
COPY ubuntu*.dep ./tiscamera/dependencies/

# Install TIS dependencies
RUN sed -i 's?"sudo", "apt"?"apt-get"?g' tiscamera/scripts/dependency-manager \
    && export DEBIAN_FRONTEND=noninteractive \
    && ./tiscamera/scripts/dependency-manager install --yes --compilation --modules base,gstreamer,v4l2 \
    && rm -rf /var/lib/apt/lists/*

# Config, build, package
RUN cmake \
    -D TCAM_ARAVIS_USB_VISION:BOOL=OFF \
    -D TCAM_BUILD_ARAVIS:BOOL=OFF \
    -D TCAM_BUILD_TOOLS:BOOL=OFF \
    -D TCAM_BUILD_LIBUSB:BOOL=OFF \
    -D TCAM_BUILD_DOCUMENTATION:BOOL=OFF \
    -S tiscamera \
    -B build_package \
    && cmake --build build_package --target package

# Build uvc extension loader only
RUN cmake \
    -D TCAM_BUILD_UVC_EXTENSION_LOADER_ONLY:BOOL=ON \
    -S tiscamera \
    -B build_package \
    && cmake --build build_package

# Use busybox as container
FROM busybox:latest

# Copy created deb
COPY --from=base /build_package/tiscamera*.deb /tiscamera.deb

# Copy udev related files
COPY --from=base /tiscamera/data/uvc-extensions /setup/usr/share/theimagingsource/tiscamera/uvc-extension
COPY --from=base /build_package/data/udev/80-theimagingsource-cameras.rules /setup/etc/udev/rules.d/80-theimagingsource-cameras.rules
COPY --from=base /build_package/bin/tcam-uvc-extension-loader /setup/usr/bin/tcam-uvc-extension-loader

# Mount point for image users to install udev rules, etc.
VOLUME [ "/setup" ]
