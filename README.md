# ros-tis

In order to use containerized tiscamera, this specific image is to be utilized as two roles: for host and container.

## For host

To fully use tiscamera, two pieces of infomation should be setup properly on host:

1. udev rule
1. uvc extension

These may be accomplished by following these steps:

```bash
# run this image once so the setup volume (via mount point) persists
docker run --rm -v ros-tis-setup:/setup zhuoqiw/ros-tis

# copy udev rule and uvc
sudo cp -r /var/lib/docker/volumes/ros-tis-setup/_data/* /

# optional, in case to save a little bit disk usage
docker volume rm ros-tis-setup

# optional, reboot otherwise
sudo udevadm control --reload-rules
```

## For container (multistage built image typically)

Install the tiscamera debian package:

1. Copy the runtime package tiscamera.deb from this image.
1. Install the package.

```Dockerfile
FROM zhuoqiw/ros-tis AS tis

FROM something-else

COPY --from=tis /tiscamera.deb tiscamera.deb
RUN apt-get update && export DEBIAN_FRONTEND=noninteractive \
    && apt-get -y install --no-install-recommends \
    python3-gi \
    ./tiscamera.deb \
    && rm -rf /var/lib/apt/lists/* ./tiscamera.deb
```
