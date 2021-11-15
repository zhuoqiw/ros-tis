# Install TIS on ROS
FROM ros:galactic AS BUILD

# Download
RUN git clone --depth 1 --branch v-tiscamera-0.14.0 https://github.com/TheImagingSource/tiscamera.git /tiscamera

# Install TIS dependencies
RUN sed -i 's?"sudo", "apt"?"sudo", "apt-get"?g' /tiscamera/scripts/dependency-manager \
  && /tiscamera/scripts/dependency-manager install -y --compilation -m base,v4l2,libusb

# Compile and install
RUN mkdir /tiscamera/build \
  && cmake \
    -D BUILD_TOOLS:BOOL=OFF \
    -S /tiscamera/ \
    -B /tiscamera/build \
  && cmake --build /tiscamera/build/ --target install \
  && rm -r /tiscamera
