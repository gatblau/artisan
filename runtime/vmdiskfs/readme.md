<img src="https://github.com/gatblau/artisan/raw/master/artisan.png" width="150" align="right"/>

# VM Disk File System Artisan Runtime

This runtime uses vmdiskfs tool written in GO which has required functions implemented to convert images from any format
to qcow2 format, but it has capability to extend functionality of the tool.

At this moment vmdiskfs tool has below functionality:
```shell
[runtime@artisan-development ~]$ vmdiskfs

++++++++++++++++++++++++++++++++++++++++++++++++
| Tool for parsing notifications, downloading, |
| converting and publishing to object storage  |
| Tool is part of artisan vmdiskfs runtime     |
++++++++++++++++++++++++++++++++++++++++++++++++

Usage:
  vmdiskfs [command]

Available Commands:
  convert     Converts images to KubeVirt format
  download    downloads file from object storage and bucket to specific folder
  help        Help about any command
  parse       parses push notification received
  upload      uploads file to object storage bucket
  version     vmdiskfs utility version

Flags:
  -h, --help   help for vmdiskfs

Use "vmdiskfs [command] --help" for more information about a command.

[runtime@artisan-development ~]$ vmdiskfs version
2021/06/28 06:44:33 Version: 0.0.1

#Coversion example:
[runtime@artisan-development ~]$ vmdiskfs convert
2021/06/28 06:52:11 Waiting for command to finish...
2021/06/28 06:52:31 Successfully Converted
```
><b>Information:</b> vmdiskfs currently parses push notifications received from AWS_S3 and MinIO, but very easy can be enhanced
 to support GCR object storage push notifications. Also very easily can be added functionality to work with encrypted object
 storages or after conversion prepare KubeVirt VM manifest and push to github or other repo.

><b>Notification:</b> vmdiskfs runtime build using docker build --squash to flat and reduce size of runtime, please enable on docker
 squash feature before building image. Before starting to build image make sure that vmdiskfs package containing tool is located in
 local art repository, Get tool from here: artisan-registry-nexus.apps.demo.openshiftdev.com/root/vmdiskfs

# Usage

See `version` function in [build](build.yaml) file.

To see which version of the tools are installed run the following command:

```sh
art runc version
```
