# Install TIS on ROS
FROM ros:galactic

# Clone repo
RUN git clone -b v-tiscamera-0.14.0 https://github.com/TheImagingSource/tiscamera.git tis_src \
  && mkdir tis_bld

# Install TIS dependencies
RUN sed -i 's?"sudo", "apt"?"sudo", "apt-get"?g' tis_src/scripts/dependency-manager \
  && ./tis_src/scripts/dependency-manager install -y -m base,gstreamer,aravis

# Compile
RUN cmake \
  -D BUILD_ARAVIS:BOOL=ON \
  -D TCAM_ARAVIS_USB_VISION:BOOL=ON \
  -D BUILD_V4L2:BOOL=OFF \
  -S tis_src/ \
  -B tis_bld/ \
  && cmake --build tis_bld/ --target install \
  && rm -r tis_src tis_bld

