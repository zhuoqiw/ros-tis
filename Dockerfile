# Build and install TIS on ROS
FROM ros:galactic

# Clone TIS repo
RUN git clone -b v-tiscamera-0.14.0 https://github.com/TheImagingSource/tiscamera.git

# Install TIS dependencies
RUN sed -i 's?"sudo", "apt"?"sudo", "apt-get"?g' tiscamera/scripts/dependency-manager \
  && ./tiscamera/scripts/dependency-manager install -y -m base,gstreamer,aravis

# Config TIS
RUN cmake \
  -D BUILD_ARAVIS:BOOL=ON \
  -D TCAM_ARAVIS_USB_VISION:BOOL=ON \
  -D BUILD_V4L2:BOOL=OFF \
  -D CMAKE_INSTALL_PREFIX:STRING=/opt/tiscamera \
  -S tiscamera \
  -B tiscamera/build

# Build TIS
RUN cmake --build tiscamera/build

# Install TIS
RUN cmake --install tiscamera/build

# Remove source
RUN rm -r tiscamera

# Update ldconfig
RUN echo "/opt/tiscamera/lib" >> /etc/ld.so.conf.d/tiscamera.conf \
  && ldconfig

