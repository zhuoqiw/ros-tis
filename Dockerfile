# Install TIS on ROS
FROM ros:galactic AS BUILD

# Download
RUN git clone --depth 1 --branch v-tiscamera-0.14.0 https://github.com/TheImagingSource/tiscamera.git /tiscamera

# Install TIS compile dependencies
RUN sed -i 's?"sudo", "apt"?"sudo", "apt-get"?g' /tiscamera/scripts/dependency-manager \
  && /tiscamera/scripts/dependency-manager install -y --compilation -m base,v4l2,libusb

# Compile
RUN mkdir /tiscamera/build \
  && cmake \
    -D CMAKE_INSTALL_PREFIX:STRING=/opt/tiscamera \
    -D BUILD_TOOLS:BOOL=OFF \
    -S /tiscamera/ \
    -B /tiscamera/build \
  && cmake --build /tiscamera/build/ --target install

FROM ros:galactic

COPY --from=BUILD /opt/tiscamera/ /opt/tiscamera/

COPY --from=BUILD /tiscamera/ /tiscamera/

# Install TIS runtime dependencies
RUN /tiscamera/scripts/dependency-manager install -y --runtime -m base,v4l2,libusb \
  && rm -r /tiscamera

# Update ldconfig
RUN echo "/opt/tiscamera/lib" >> /etc/ld.so.conf.d/tiscamera.conf \
  && ldconfig
