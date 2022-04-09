# Build and install TIS on ROS
FROM ros:galactic

# Clone TIS repo
RUN git clone -b v-tiscamera-0.14.0 https://github.com/TheImagingSource/tiscamera.git

# Install TIS dependencies
RUN sed -i 's?"sudo", "apt"?"sudo", "apt-get"?g' tiscamera/scripts/dependency-manager \
  && export DEBIAN_FRONTEND=noninteractive \
  && ./tiscamera/scripts/dependency-manager install -y \
  && rm -rf /var/lib/apt/lists/*

# Config, build, install TIS
# RUN cmake \
#   -S tiscamera \
#   -B tiscamera/build \
#   && cmake --build tiscamera/build \
#   && cmake --install tiscamera/build \
#   && rm -r tiscamera

