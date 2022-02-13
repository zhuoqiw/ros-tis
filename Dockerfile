# Install TIS on ROS
FROM ros:galactic

# URL
ARG TIS_TAR_GZ=https://github.com/TheImagingSource/tiscamera/archive/refs/tags/v-tiscamera-0.14.0.tar.gz

# Install dependencies
RUN apt-get update && apt-get install -y --no-install-recommends \
  wget \
  && rm -rf /var/lib/apt/lists/*

# Download
RUN wget -O tis.tar.gz ${TIS_TAR_GZ} --no-check-certificate \
  && mkdir -p tis/build \
  && tar -xzf tis.tar.gz --strip-components=1 -C tis \
  && rm tis.tar.gz

# Install TIS dependencies
RUN sed -i 's?"sudo", "apt", "install"?"sudo", "apt-get", "install"?g' tis/scripts/dependency-manager \
  && tis/scripts/dependency-manager install -y --no-update -m base,gstreamer,aravis

# Compile
RUN cmake \
  -D BUILD_ARAVIS:BOOL=ON \
  -D TCAM_ARAVIS_USB_VISION:BOOL=ON \
  -D BUILD_V4L2:BOOL=OFF \
  -S tis/ \
  -B tis/build/ \
  && cmake --build tis/build/ --target install
