# Install TIS on ROS
FROM ros:galactic

# URL
ARG TIS_TAR_GZ=https://github.com/TheImagingSource/tiscamera/archive/refs/tags/v-tiscamera-0.14.0.tar.gz

# Install dependencies
RUN apt-get update && apt-get install -y --no-install-recommends \
  wget \
  && rm -rf /var/lib/apt/lists/*

# Download
RUN wget -O tis.tar.gz ${TIS_TAR_GZ} \
  && mkdir tis-src tis-bld \
  && tar -xzf tis.tar.gz --strip-components=1 -C tis-src \
  && rm tis.tar.gz

# Install TIS dependencies
RUN sed -i 's?"sudo", "apt"?"sudo", "apt-get"?g' tis-src/scripts/dependency-manager \
  && tis-src/scripts/dependency-manager install -y -m base,v4l2,libusb

# Compile
RUN cmake \
  -D CMAKE_INSTALL_PREFIX=/opt/tiscamera \
  -D BUILD_TOOLS:BOOL=OFF \
  -S tis-src/ \
  -B tis-bld/ \
  && cmake --build tis-bld/ --target install \
  && rm -r tis-src tis-bld
