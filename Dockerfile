# Install TIS on ROS
FROM ros:galactic

# Download
RUN git clone --depth 1 --branch v-tiscamera-0.14.0 https://github.com/TheImagingSource/tiscamera.git

# Install TIS dependencies
RUN sed -i 's?"sudo", "apt"?"sudo", "apt-get"?g' tiscamera/scripts/dependency-manager \
  && tiscamera/scripts/dependency-manager install -y \
  && rm -rf /var/lib/apt/lists/*

# Compile and install
RUN mkdir tiscamera/build \
  && cmake \
    -D BUILD_ARAVIS=ON \
    -D BUILD_V4L2=OFF \
    -D BUILD_LIBUSB=OFF \
    -D TCAM_ARAVIS_USB_VISION=ON \
    -S tiscamera/ \
    -B tiscamera/build \
  && cmake --build tiscamera/build/ --target install \
  && rm -r tiscamera
