# Install TIS on ROS
FROM ubuntu:18.04

# Install dependencies
RUN apt-get update && apt-get install -y --no-install-recommends \
  wget \
  libzip4 \
  libglib2.0-0 \
  libgirepository-1.0-1 \
  libusb-1.0-0 \
  libgstreamer1.0-0 \
  gstreamer1.0-plugins-base \
  gstreamer1.0-plugins-good \
  gstreamer1.0-plugins-bad \
  gstreamer1.0-plugins-ugly \
  libxml2 \
  libpcap0.8 \
  python3-pyqt5 \
  python3-gi \
  python3-gst-1.0 \
  python-gi \
  python-gst-1.0 \
  dialog \
  apt-utils \
  && rm -rf /var/lib/apt/lists/*

# Download and install and remove
RUN wget https://github.com/TheImagingSource/tiscamera/releases/download/v-tiscamera-0.14.0/tiscamera_0.14.0.3054_amd64_ubuntu_1804.deb --no-check-certificate
# \
#  && apt-get install -y ./tiscamera_0.14.0.3054_amd64_ubuntu_1804.deb \
#  && rm tiscamera_0.14.0.3054_amd64_ubuntu_1804.deb

