# Artisan Runtime Base Images

In order to facilitate the process of creating your own runtime, these base images should be used to ensure
the created runtime is compatible with Artisan.

Artisan runtimes are built on either a [Red Hat Universal Base Image](https://developers.redhat.com/articles/ubi-faq#) or on official Docker [Ubuntu Image](https://hub.docker.com/_/ubuntu)

*To ensure containers you build using Red Hat UBI's can be redistributed, the base images disable non-UBI yum repositories.*

To create a runtime:

```Dockerfile
# start from one of the base images (e.g. ubi, ubi-min, ubuntu)
# use ubi-min where possible as it is smaller, if you need a more complete linux use ubi or ubuntu
FROM quay.io/artisan/ubi-min

# install tool set here

# set the user as runtime
USER runtime
```