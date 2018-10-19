docker-r-jupyter
================

Dockerfile for R with Jupyter Notebook

Docker image
------------

Pull the image from [Docker Hub](https://hub.docker.com/r/dceoy/r-jupyter/).

```sh
$ docker pull dceoy/r-jupyter
```

Usage
-----

Run a server

```sh
$ docker container run --rm -p=8888:8888 -v=${pwd}:/nb -w=/nb dceoy/r-jupyter
```

Run a server with docker-compose

```sh
$ docker-compose -f /path/to/docker-jupyter/docker-compose.yml up
```
