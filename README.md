docker-r-jupyter
================

Dockerfile for R with JupyterLab

[![CI to Docker Hub](https://github.com/dceoy/docker-r-jupyter/actions/workflows/docker-publish.yml/badge.svg)](https://github.com/dceoy/docker-r-jupyter/actions/workflows/docker-publish.yml)

Docker image
------------

Pull the image from [Docker Hub](https://hub.docker.com/r/dceoy/r-jupyter/).

```sh
$ docker image pull dceoy/r-jupyter
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

Dependency
----------

The image uses the following tool:

- clir
  - R package manager for command line interface
  - [GitHub - dceoy/clir](https://github.com/dceoy/clir)
  - [DockerHub - dceoy/clir](https://hub.docker.com/r/dceoy/clir)
