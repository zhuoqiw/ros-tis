# Install TIS on ROS
FROM ubuntu:18.04

# Install dependencies
RUN apt-get update && apt-get install -y --no-install-recommends \
  git \
  && rm -rf /var/lib/apt/lists/*

# Download
RUN git clone --depth 1 --branch v-tiscamera-0.14.0 https://github.com/TheImagingSource/tiscamera.git

# Install TIS dependencies
RUN sed -i 's?"sudo", "apt"?"sudo", "apt-get"?g' tiscamera/scripts/dependency-manager \
  && tiscamera/scripts/dependency-manager install -y \
  && rm -rf /var/lib/apt/lists/*

# Compile and install
RUN mkdir tiscamera/build \
  && cmake \
    -S tiscamera/ \
    -B tiscamera/build \
  && cmake --build tiscamera/build/ --target install \
  && rm -r tiscamera
