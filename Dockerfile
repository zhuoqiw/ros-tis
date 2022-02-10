# Install TIS on ROS
FROM ubuntu:18.04

# Install dependencies
RUN apt-get update && apt-get install -y --no-install-recommends \
  wget \
  && rm -rf /var/lib/apt/lists/*

# Download
RUN wget https://github.com/TheImagingSource/tiscamera/archive/refs/tags/v-tiscamera-0.14.0.tar.gz --no-check-certificate \
  && tar -xzf v-tiscamera-0.14.0.tar.gz \
  && rm v-tiscamera-0.14.0.tar.gz

# Install TIS dependencies
RUN sed -i 's?"sudo", "apt"?"sudo", "apt-get"?g' v-tiscamera-0.14.0/scripts/dependency-manager \
  && v-tiscamera-0.14.0/scripts/dependency-manager install -y \
  && rm -rf /var/lib/apt/lists/*

# Compile and install
RUN mkdir v-tiscamera-0.14.0/build \
  && cmake \
    -S v-tiscamera-0.14.0/ \
    -B v-tiscamera-0.14.0/build \
  && cmake --build v-tiscamera-0.14.0/build/ --target install \
  && rm -r v-tiscamera-0.14.0
