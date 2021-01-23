# Artisan Runtime Base Images

In order to facilitate the process of creating your own runtime, these base images should be used to ensure
the created runtime is compatible with Artisan.

Artisan runtimes are [Built on Red Hat Universal Base Image](https://developers.redhat.com/articles/ubi-faq#).

*To ensure the containers you build can be redistributed, the base images disable non-UBI yum repositories.*

To create a runtime:

```Dockerfile
# start from one of the base images (e.g. ubi or ubi-min)
# use ubi-min where possible as it is smaller, if you need a more complete linux use ubi
FROM quay.io/artisan/ubi-min

# install tool set here

# set the user as runtime
USER runtime
```