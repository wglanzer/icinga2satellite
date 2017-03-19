# icinga2satellite
[![Docker Automated buil](https://img.shields.io/docker/automated/jrottenberg/ffmpeg.svg)](https://hub.docker.com/r/cybroken/icinga2satellite/)

This image represents a preconfigured satellite for icinga2.  
It connects to a single icinga2 master. Multi-endpoints are not supported yet!

## Environment variables Reference

| Name | Description |
| ---------------------- | ----------- |
| `NODE_NAME` | Name of this node. It should be the FQDN of your container |
| `NODE_ZONE` | Zone which this node belongs to |
| `MASTER_HOST` | Adress of your Master-Host |
| `MASTER_PORT` | Port of your Master-Host (default: 5665) |
| `PKI_TICKET` | Request ticket generated on the MASTER_HOST-Server (`icinga2 pki ticket --cn NODE_NAME`) |

## Docker-Compose
```yml
satellite:
  image: cybroken/icinga2satellite
  volumes:
    - ./run/services.conf:/etc/icinga2/conf.d/services.conf
  environment:
    NODE_NAME: "testcontainer"
    NODE_ZONE: "containers"
    MASTER_HOST: "master.example.com"
    PKI_TICKET: "abcdefghijkd48a1f996d6e36c3183407da197c2" 
```
