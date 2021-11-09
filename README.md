# image-server-node-iipsrv-openjpeg

A multi stage Dockerfile that builds openjpeg 2.4.0 and copies output to a new stage. 

The new stage runs precompiled IIP Image with openjpeg via lighttpd.

This has been pushed to ghcr as `ghcr.io/dlcs/iipsrv-openjpeg:2.4.0` and `ghcr.io/dlcs/iipsrv-openjpeg:2.4.0`

## Running

```sh
docker build -t iipsrv-openjpeg:local .

docker run -d -p 8080:8080 -v /efs:/efs --name iip iipsrv-openjpeg:local ./operations.sh
```
