---
layout: page
title: Your First Docker Application
permalink: /tutorial/first-docker-application/
---

Now that we installed Docker, we'll jump right in by building an running our
first image.

In the previous step, we used Docker to run the *hello-world* image, a basic
tool that outputs some information we can use to verify that Docker is working.

In this section, we'll build and run a real application: the Jekyll static site
generator. As you remember, we'll use Jekyll to compile the source files for
this tutorial itself into a website that we can view in our web browser. After
doing so, we'll continue the tutorial from the website running on your local
machine in a Docker container!

### Download the Project

First, we need to retrieve the source files for this website. We'll use *git*
to pull in a copy of the files from GitHub:

```
git clone https://github.com/cyrossignol/docker-quickstart.git
```

This will create a directory containing the project's files. Let's change into
that directory and list the files:

```
cd docker-quickstart && ls
```

We can ignore most of these files because we don't need to know how Jekyll
works for this tutorial. However, notice the *Dockerfile* in this directory.
This file contains instructions that tell Docker how to build the image for our
project. We'll examine this file in an upcoming section.

### Build the Project Image

For now, let's build our image:

```
docker build -t docker-quickstart .
```

You'll notice Docker churning through each of the instructions in the
Dockerfile as it builds the image. When the build process finishes, it stores
the final image in the Docker Engine. We can see our shiny new image by
running:

```
docker images
```

### Running the Image

Now, let's fire up the image we built by running it in a container:

```
docker run -it --rm --name docker-quickstart -p 4000:4000 docker-quickstart
```

The `docker run` command takes quite a few arguments that we'll explore and
streamline later.  After executing this command, we should see information from
Jekyll as it builds our website. The container will then start a webserver and
wait for requests. If needed, `Ctrl + C` terminates the webserver (and, as a
result, the Docker container) and returns control to the terminal.

With the webserver running, we can now take a look at the website we just
built. Windows and Mac users with Docker Machine need to connect to the IP
address of the virtual machine running the Docker Engine to access services
running in containers. The Docker Quickstart Terminal displays this IP address
when it starts up, or we can use the following command to find the IP address:

```
docker-machine ip
```

...which displays something like **192.168.99.100**. This address may be
different on your local machine. We'll connect to Jekyll's built-in webserver
on port **4000**:

[http://192.168.99.100:4000/docker-quickstart/](http://192.168.99.100:4000/docker-quickstart/)

Linux users running Docker natively can reach the website at **127.0.0.1** on
port **4000**:

[http://127.0.0.1:4000/docker-quickstart/](http://127.0.0.1:4000/docker-quickstart/)

If you see this tutorial in your web browser, you successfully built and ran a
Docker application. Congratulations! As we can see, Docker makes it easy to run
applications in complex environments that would otherwise take a long time to
set up.

You may now continue the tutorial in your web browser using the website that
you just built!

Or, continue the tutorial online:
[Images and Containers](../images-and-containers/)
