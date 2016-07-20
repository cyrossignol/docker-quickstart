---
layout: page
title: Docker Overview
permalink: /tutorial/docker-overview/
---

Docker is a group of tools used to create, transfer, and run applications
inside containers. We call this practice *containerization*. Containerized
applications execute in a virtual environment on a host computer running the
Docker Engine.

Containerization
----------------

From a conceptual point of view, containerization enables us to wrap up an
application, along with any components it needs to run, into a specially
formatted package that will function as expected on any machine that is
compatible with that standard package format, regardless of the host operating
system or its configuration. The wrapped application could be a simple shell
script, a database, or even a full web application. The host machine running
the container doesn't care about the package contents as long as the package
itself is valid. This makes containerized applications very portable.

The Docker community often compares the Docker system to the practice of
containerization in the shipping industry. Companies pack goods into
internationally standardized shipping containers that can be loaded,
transported, and unloaded using vehicles and machinery compatible with those
standardized containers without the need to know about the contents inside.
For example, we could place lab equipment in one shipping container, and
clothing in another, and load both onto a boat that carries them overseas.
Upon arriving, the containers are unloaded onto a train that delivers the
contents to their destination. Neither the boat nor the train need to handle
the lab equipment or clothing explictly--they work only with the containers.

Docker Components
-----------------

The Docker system includes a system service--the Docker Engine--that performs
core functionality, such as building and running containers, and several tools
used to interact with that service.

Here's a list of some of the most important components that we need to know.
We'll describe each briefly and cover them in more detail throughout the
tutorial.

- Docker Engine
    - Images
    - Containers
    - Volumes
    - Networks
- Docker Command Line Interface (CLI)
- Dockerfiles
- Image Registries
- Docker Toolbox
    - Docker Machine
    - Docker Compose
    - Kitematic

### Docker Engine

As the core of the Docker system, Docker Engine executes all the functions that
we'll use Docker for: downloading and building images, running containers,
and coordinating between the host machine and our containerized applications.

The Docker Engine manages the following aspects that we'll explore in this
guide:

- **Images**: The "blueprints" for containers. Contain the filesystem and
  configuration Docker uses to run a container after building from a Dockerfile
- **Containers**: Images that are running. Our "dockerized" applications
  execute inside containers.
- **Volumes**: The data storage units of Docker. We'll write persistant data to
  Docker volumes from running containers
- **Networks**: Virtual container-to-container or container-to-host networking

The Engine runs as a system service (daemon) on a host computer. We don't
usually interact with this service directly. Instead, Docker Engine provides
an API that accepts commands from other programs like the Docker CLI.

### Docker Command Line Interface (CLI)

We'll use the Docker CLI to send commands to the Docker Engine. We can usually
invoke this program using the `docker` command. For example, to build an image,
we'll execute the following command:

```
docker build -t docker-quickstart .
```

The CLI doesn't perform this functionality itself. Instead, it sends our request
to a running Docker Engine service.

### Dockerfiles

Dockerfiles are a set of instructions read by the Docker Engine used to build
and configure an image. When building a custom image for a project, we'll
create a Dockerfile that tells Docker how to set up the environment needed to
run the project.

### Image Registries

Registries contain pre-built Docker images. After building an image for an
application in development, we can push the final image to an image registry
and pull the image for deployment on production servers. This process is
similar to the way developers push and pull source code to repositories like
[GitHub](https://github.com).

Registries often contain reusable base images as well.
[Docker Hub](https://hub.docker.com), the official Image Registry of Docker,
includes pre-built images for common operating systems and programming
environments that we can use to build custom images for our projects.

### Docker Toolbox

[Docker Toolbox](https://www.docker.com/products/docker-toolbox) includes
the Docker Engine itself, along with some useful tools that we'll use in
this tutorial:

- **Docker Compose**: Simplifies the process of building and running Docker
  applications by allowing us to define arguments in a file.
- **Docker Machine**: Quickly sets up and manages virtual machines that run
  the Docker Engine. Windows and Mac users use Machine to set up Docker on
  their local computer.
- **Kitematic**: A graphical user interface to the Docker Engine that manages
  running containers. Also provides an interface to browse and download images
  on Docker Hub.

Onward
------

Keep these components in mind as we continue through this tutorial. We'll learn
how they tie together.

Now, let's install Docker: [Installation](../install-docker/)
