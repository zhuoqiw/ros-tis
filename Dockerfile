# Install TIS on ROS
FROM ubuntu:18.04

# Install dependencies
RUN apt-get update && apt-get install -y --no-install-recommends \
  wget \
  python3 \
  && rm -rf /var/lib/apt/lists/*

# Download
RUN wget -O tis.tar.gz https://github.com/TheImagingSource/tiscamera/archive/refs/tags/v-tiscamera-0.14.0.tar.gz --no-check-certificate \
  && mkdir tis \
  && tar -xzf tis.tar.gz --strip-components=1 --directory=tis \
  && rm tis.tar.gz

# Install TIS dependencies
RUN sed -i 's?"sudo", "apt"?"sudo", "apt-get"?g' tis/scripts/dependency-manager \
  && tis/scripts/dependency-manager install -y \
  && rm -rf /var/lib/apt/lists/*

# Compile and install
RUN mkdir tis/build \
  && cmake \
    -S tis/ \
    -B tis/build \
  && cmake --build tis/build/ --target install \
  && rm -r tis
