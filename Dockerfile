# Build and install TIS on ROS
FROM ros:galactic

# Clone TIS repo
RUN git clone -b v-tiscamera-0.14.0 https://github.com/TheImagingSource/tiscamera.git

# Install TIS dependencies
RUN sed -i 's?"sudo", "apt"?"sudo", "apt-get"?g' tiscamera/scripts/dependency-manager \
  && ./tiscamera/scripts/dependency-manager install -y -m base,gstreamer,aravis

# Config, build, install TIS
RUN cmake \
  -D BUILD_ARAVIS:BOOL=ON \
  -D TCAM_ARAVIS_USB_VISION:BOOL=ON \
  -D BUILD_V4L2:BOOL=OFF \
  -S tiscamera \
  -B tiscamera/build \
  && cmake --build tiscamera/build \
  && cmake --install tiscamera/build \
  && rm -r tiscamera

