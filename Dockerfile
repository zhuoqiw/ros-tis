# Install TIS on ROS
FROM ros:galactic

# Clone repo
RUN git clone --depth 1 --branch v-tiscamera-0.14.0 https://github.com/TheImagingSource/tiscamera.git tis \
  && mkdir tis/build

# Install TIS dependencies
RUN sed -i 's?"sudo", "apt", "install"?"sudo", "apt-get", "install"?g' tis/scripts/dependency-manager \
  && sed -i 's?"sudo", "apt", "update"?"sudo", "apt-get", "update"?g' tis/scripts/dependency-manager \
  && ./tis/scripts/dependency-manager install -y -m base,gstreamer,aravis

# Compile
RUN cmake \
  -D BUILD_ARAVIS:BOOL=ON \
  -D TCAM_ARAVIS_USB_VISION:BOOL=ON \
  -D BUILD_V4L2:BOOL=OFF \
  -S tis/ \
  -B tis/build/ \
  && cmake --build tis/build/ --target install

