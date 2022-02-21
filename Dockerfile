# Install TIS on ROS
FROM ros:galactic

# Clone repo
RUN git clone -b v-tiscamera-0.14.0 https://github.com/TheImagingSource/tiscamera.git \
  && mkdir tiscamera/build

# Install TIS dependencies
RUN sed -i 's?"sudo", "apt"?"sudo", "apt-get"?g' tiscamera/scripts/dependency-manager \
  && ./tiscamera/scripts/dependency-manager install --compilation -y -m base,gstreamer,aravis

# Compile
RUN cmake \
  -D BUILD_ARAVIS:BOOL=ON \
  -D TCAM_ARAVIS_USB_VISION:BOOL=ON \
  -D BUILD_V4L2:BOOL=OFF \
  -D CMAKE_INSTALL_PREFIX:STRING=/opt/tiscamera \
  -S tiscamera/ \
  -B tiscamera/build/ \
  && cmake --build tiscamera/build/

FROM ros:galactic

COPY --from=0 tiscamera tiscamera

RUN ./tiscamera/scripts/dependency-manager install --runtime -y -m base,gstreamer,aravis

RUN cmake --build tiscamera/build/ --target install \
  && rm -r tiscamera

RUN echo "/opt/tiscamera/lib" >> /etc/ld.so.conf.d/tiscamera.conf \
  && ldconfig

