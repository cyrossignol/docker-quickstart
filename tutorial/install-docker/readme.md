---
layout: page
title: Install Docker
permalink: /tutorial/install-docker/
---

For this tutorial, we'll install the Docker Toolbox, which contains the Docker
Engine and several tools that we'll cover in the following sections.

Windows and Mac OSX
-------------------

Follow this link to download and run the installer for the Docker Toolbox for
your operating system:
[Docker Toolbox](https://www.docker.com/products/docker-toolbox).

We don't need to reproduce the installation instructions for the Docker Toolbox
here. Please follow the instructions for your operating system:

- [Windows](https://docs.docker.com/toolbox/toolbox_install_windows/)
- [Mac](https://docs.docker.com/toolbox/toolbox_install_mac/)

These instructions will guide you through the installation process and initial
configuration. At the end of the process, you'll run the *hello-world* image to
verify that your installation works correctly.

When you finish all of the installation steps, you should have a Docker Engine
running using Docker Machine inside VirtualBox. Docker Machine is a virtual
machine manager for Docker Engine guest operating systems. Because the Docker
Engine requires a Linux environment to operate, Windows and Mac users must run
it inside a virtual machine.

Many of us new to Docker confuse the Docker Machine guest operating system
running inside the virtual machine with actual Docker images and containers.
This special virtual machine enables us to run Docker applications on a
non-Linux system. The containers that we will eventually run actually execute
in the Docker environment inside the virtual machine. Docker automatically sets
up filesystem mappings from our host machine to the running Docker Machine
instance using the VirtualBox shared folders so we can execute Docker commands
on our host system without the need to SSH into the virtual machine.

The Docker Toolbox includes the Docker Quickstart Terminal and Kitematic which
set up Docker Machine for us. For this tutorial, we'll use the Docker Quickstart
Terminal to execute any `docker` commands.

**Note**: *At the time of writing, Docker released beta versions of the Docker
Engine that runs using native virtualization in Windows and Mac. You may
experiment with these versions if you prefer, but we'll assume for this
tutorial that we're running the Docker Engine inside Docker Machine.*

Linux
-----

Docker runs natively on Linux, so Docker doesn't provide a Docker Toolbox
package for these operating systems. Instead follow the instructions for your
distribution to install the Docker Engine:

[Installation on Linux](https://docs.docker.com/engine/installation/linux/)

If you didn't run the *hello-world* image as part of the installation procedure
for your distribution, let's try it out now to make sure your Docker
installation functions as expected:

```
docker run --rm hello-world
```

**Note**: *You may need to execute this command as root or with `sudo`.*

Alternatively, Linux users may wish to install Docker in a virtual machine
using Docker Machine and VirtualBox if finding difficulties with a native
installation:

1. [Install Docker Machine](https://docs.docker.com/machine/install-machine/)
2. [Get started with Docker Machine](https://docs.docker.com/machine/get-started/)

Next, we'll need to install Docker Compose, a tool that we'll use later in the
tutorial. Some distributions provide this tool in their package repository.

In Ubuntu, for example, we can install Compose through APT repositories:

```
apt-get update && apt-get install docker-compose
```

If your distribution does not provide an official package, follow these instructions
to install Compose:

[Install Docker Compose](https://docs.docker.com/compose/install/)

**Note**: *Kitematic is not currently supported on Linux.*

Onward
------

Now that we have Docker, we can run our first real application:
[Your First Docker Application](../first-docker-application/)
