# Install TIS on ROS
FROM ubuntu:18.04

# Install dependencies
RUN apt-get update && apt-get install -y --no-install-recommends \
  wget \
  && rm -rf /var/lib/apt/lists/*

# Download and install and remove
RUN wget -O tis.deb https://github.com/TheImagingSource/tiscamera/releases/download/v-tiscamera-0.14.0/tiscamera_0.14.0.3054_amd64_ubuntu_1804.deb --no-check-certificate \
  && apt-get install ./tis.deb \
  && rm tis.deb

