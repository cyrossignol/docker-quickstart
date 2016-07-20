---
layout: page
title: Building Images From Dockerfiles
permalink: /tutorial/building-images-from-dockerfiles/
---

In a previous section, we ran the following command to build the image for this
tutorial:

```
docker build -t docker-quickstart .
```

This command told the Docker Engine to build an image using the files in the
specified directory (in our case, `.`, the current directory). Docker looks for
a *Dockerfile* in that directory. This file contains instructions that Docker
follows to build the image.

Docker executes each instruction as an atomic unit and saves the state of the
current image it builds after running each instruction. This process is similar
to the way that a version control system for code, such as git, tracks each
commit as a unit of change.

Among other benefits, this system enables Docker to cache each build step after
each instruction. When we modify a Dockerfile and rebuild the image, Docker
reuses all the cached steps before the modified instruction, potentially saving
a huge amount of time when rebuilding complex images.

We can group Dockerfile instructions into two categories:

 1. Instructions that modify the underlying state of the image filesystem
 2. Instructions that configure how Docker will execute the final image

We'll break down the instructions in the Dockerfile for this project to learn
how Docker builds an image.

### FROM Instruction

Let's look at our first instruction:

```dockerfile
FROM ruby:2.3.1-alpine
```

Almost every Docker image is based on a parent image that provides the
boilerplate system for a targeted application image. When creating an image for
a project, we want to create the smallest environment needed to run the project
application with as few programs and services running as possible.

We also don't want to repeat the work needed to create the prerequisites for
our application-specific image. For example, in most cases we don't need to
install a Linux operating system by hand. Instead, we'll use a pre-built image
containing a configured environment that we'll tweak for our application.

For this tutorial, we want to create an image capable of running the Jekyll
static site generator. Jekyll is a Ruby application, so we'll need to build an
environment capable of running Ruby applications.

We'll base this image on the official `ruby` image, which contains a minimal
[Alpine Linux](http://alpinelinux.org) system with only the Ruby programming
language and its dependencies installed.

The `FROM` instruction directs Docker to base the image on another image.  The
resulting image will inherit the entire filesystem from the parent image, along
with any configuration instructions from the parent Dockerfile.  Docker will
attempt to resolve the parent image from the machine running Docker. If this
image doesn't exist locally, Docker will attempt to fetch the image from a
remote image registry. [Docker Hub](https://hub.docker.com) is the default
image registry and contains official images for a variety of environments,
services, operating systems, and programming languages.

The parent image name, in this case, `ruby`, preceeds the colon in the `FROM`
instruction. After the colon, we'll specify a tag. Tags describe variations of
the base image and often refer to a version of the software in the image.  The
tag above is `2.3.1-alpine`, which indicates that the Ruby image we're building
from should contain version 2.3.1 of the Ruby language running in an Alpine
Linux environment.

**Note**: *Many Docker image repositories include variations of an image built
with [Alpine Linux](http://alpinelinux.org) instead of a more common
distribution because of Alpine's incredibly small size (~5 MB vs ~190 MB for a
minimal Ubuntu image). This reduces the storage and transfer overhead of the
images.*

**Note**: *For those curious to know how organizations build their official
images, visit the repository for that image and take a look at the Dockerfile.
You can find Ruby's here:*

[Official Ruby Docker Repository](https://github.com/docker-library/ruby)

### MAINTAINER Instruction

The next instruction has little impact on the execution of the final image.
Docker and image registries use the `MAINTAINER` instruction to display
information about the person or organization that maintains an image.

```dockerfile
MAINTAINER Cy Rossignol <cy@rossignols.me>
```

### ENV Instruction

Next, we'll use the `ENV` instruction to set some enviorment variables.  These
variables are available to the system we're building immediately after we
declare them in this Dockerfile, so we can use them in any `RUN` instructions
that follow. They remain set in the final image.

For this example, we'll set some local encoding defaults. It's always good to
be explicit about character encoding.

```dockerfile
ENV LANGUAGE=en_US \
    LANG=en_US.UTF-8 \
    LC_ALL=en_US
```

We can use `\` (backslash) as an escape character to spread an instruction
across multiple lines for easier reading. Also, instead of declaring three
instructions, one for each environment variable, we should combine related
instructions into a single instruction when possible because Docker creates an
intermediary image after each instruction when building an image. This practice
improves build performance and reduces the number of intermediary images stored
in the Docker Engine.

### RUN Instruction

Until now, we haven't modified the filesystem inherited from the parent `ruby`
image. Because we're building this example image to run a Jekyll environment,
we need to install Jekyll and its dependencies.

Docker provides the `RUN` instruction to execute commands in the system we're
building. It's important to understand that we use `RUN` to execute commands
used to set up the image during the image's *build* stage, not to start
services or programs that we will use the final image for. For example, we'll
use `RUN` to install Jekyll for our example application, but we won't execute
the `jekyll` command itself using this instruction. We'll define programs and
services to start after Docker builds the final image using the `CMD` and
`ENTRYPOINT` instructions at the end of this Dockerfile.

First, we'll instruct Docker to install dependencies for Jekyll using the `apk`
command, the package manager used by Alpine Linux.

**Note**: *Because we're building an image based on Alpine Linux, these
commands are specific to that distribution. Docker can only `RUN` commands
accessible on the underlying system. For the purpose of this tutorial, you
don't need to know how the `apk` tool works. We're just installing dependencies
for our example application :)*

```dockerfile
RUN apk add --no-cache --virtual jekyll-build-deps \
    build-base \
    ruby-dev \
 && apk add --no-cache ruby-io-console
```

Next, we'll use `RUN` again to instruct Docker to install the Jekyll Ruby
package. Instead of `apk`, this time we'll run the `gem` command (Ruby's
package manager) to install the Jekyll gem itself.

```dockerfile
RUN gem update --system && gem install jekyll
```

Finally, we'll clean up remnants from the Jekyll installation process that we
don't need to actually run Jekyll. To follow good image design, we should
always remove items from the image that the final image doesn't need to provide
its services. This practice keeps container sizes low and may improve
performance or security in some cases.

```dockerfile
RUN apk del jekyll-build-deps libffi-dev openssl-dev yaml-dev zlib-dev \
 && rm /usr/local/bundle/cache/*
```

### COPY Instruction

Now that we've installed the tools we need to run our example application, we
need to set up the structure for the application itself.

We're creating an environment to build and host a static site, so we need to
give it a location in the image's filesystem where the site files will exist.

Let's tell Docker to create that directory:

```dockerfile
RUN mkdir -p /src/docker-quickstart
```

We'll install our example application into the directory we just created using
the `COPY` instruction. As its name implies, `COPY` *copies* the specified
files from the location where we're building an image on the host machine into
a directory in the image's filesystem.

Our example application builds and serves this tutorial itself as a website, so
we'll copy all of the site's source files to the directory in the image.


```dockerfile
COPY ./ /src/docker-quickstart
```

The `COPY` instruction only copies files from the same directory as the
Dockerfile we're building or below. The build would fail at the following
instruction because `../` refers to the directory above our build location:

```dockerfile
COPY ../ /src/docker-quickstart
```

### WORKDIR Instruction

We'll next direct Docker to set the working directory in the image using the
`WORKDIR` instruction. This changes the execution context of the system we're
building to the specified directory, similar to the `cd` shell command.  Docker
sets the working directory of the final image to the path specified in the last
`WORKDIR` instruction.

Because we intend for this example image to only run Jekyll on our site files,
we'll set the image's working directory to the location we just created with
the previous instruction.

```dockerfile
WORKDIR /src/docker-quickstart
```

### EXPOSE Instruction

Our example image runs the Jekyll static site generator to build our example
website from the source files in the directory we just created. To view our
site in a browser, this image must also provide a web server that answers HTTP
requests for the generated site files.

Web servers typically serve websites on *port 80*. By default, however, Docker
prevents access to services in an image by closing all un-needed ports. This
configuration improves security by limiting access to only the services
provided by an image.

We'll use the `EXPOSE` instruction to direct Docker to open certain ports when
running the final image. By exposing a port, we enable a client, such as a web
browser, to connect to a running service on that port, such as the web server
that we need.

You may notice that we never instructed Docker to install a web server in the
preceeding steps. Instead, we'll use Jekyll's built-in web server to serve our
site's files. This built-in server listens for requests on *port 4000*.

Let's instruct Docker to open that port:

```dockerfile
EXPOSE 4000
```

### CMD and ENTRYPOINT Instructions

At this point, we instructed Docker to set up everything we need to run our
example application and website from the final image:

  1. We set up a Ruby environment in Linux by basing our image on a pre-built
     Docker image containing Alpine Linux and the Ruby programming language.
  2. We installed the Jekyll tool and its dependencies.
  3. We installed our application's source files in the image's filesystem.
  4. We opened a port so our web browser can send requests for our site to a
     webserver in our image when we run it.

To finish up, we just need to tell Docker how to run the final image. When we
run this image, we want to automatically use the Jekyll tool, so we'll instruct
Docker to execute the `jekyll` command when the image boots up by using the
`CMD` and `ENTRYPOINT` instructions:

```dockerfile
CMD ["serve","-H","0.0.0.0","."]
ENTRYPOINT ["jekyll"]
```

As you might guess, the `ENTRYPOINT` instruction simply tells docker to execute
the `jekyll` command after starting the image.

The `CMD` instruction in the above example allows us to specify default
arguments for the command declared with the `ENTRYPOINT` instruction.
Together, these two instructions result in the execution of the following
command when we run the final image without any arguments:

```
jekyll serve -H 0.0.0.0 .
```

With these two instructions, the Jekyll built-in webserver will start by
default for our site when running this image without any additional input
required on our part.

Although you don't need to know how `jekyll` works for this tutorial, let's
examine this command to better understand the Docker context:

  >`jekyll serve`
   ...starts Jekyll's built in webserver so we can access the generated site
   from our web browser.

  >`-H 0.0.0.0`
  ...tells the Jekyll webserver to listen on all network interfaces. By
  default, this webserver only listens for requests on *127.0.0.1*, the running
  image's internal network interface. Because we want to view the site from
  outside the running image in our browser, we need to tell Jekyll to listen
  for requests on an external interface, or in this case, all external
  interfaces (*0.0.0.0*).

  >`.`
  ...refers to the current directory (represented by a dot or period). The
  `jekyll serve` command will serve files from a specified directory. Because
  we set the image's working directory above in this Dockerfile using the
  `WORKDIR` instruction, the current directory is `/srv/docker-quickstart`, so
  we can execute any `jekyll` commands in the context of our example site's
  source files.

Because we set `jekyll` as the entrypoint for this image, the `jekyll` command
will always run when Docker starts the image. However, we're not limited to the
default arguments defined in the `CMD` instruction. For example, we can pass
`build --watch` as arguments when running this image and Docker will run the
Jekyll's `build` command instead of starting the built-in Jekyll webserver:

```
docker run -it --rm docker-quickstart build --watch
```

...will execute the following command in the running image:

```
jekyll build --watch
```

When the image starts, this command directs Jekyll to rebuild our example site
and rebuild it again when any of the files change. Of course, we won't be able
to view the site in our browser because `jekyll build` only rebuilds the site
without starting the webserver. We'll cover starting and running already-built
images with more detail later in this tutorial.

As you can see, we defined the `CMD` and `ENTRYPOINT` instructions above using
an array syntax, where the command and each argument are elements of this
array. Here's a generic example of this syntax:

```dockerfile
CMD ["command-name","argument1","argument2","argument3",...]
ENTRYPOINT ["command-name","argument1","argument2","argument3",...]
```

The command name is always the first element of the array. This is the
preferred syntax according to the Docker docs, but other forms of these
instructions exist. Visit the documentation for more information.

In our Dockerfile, the `CMD` instruction only contains arguments, and the
`ENTRYPOINT` instruction only contains the command name to run. However, the
above example demonstrates that the `CMD` instruction can define a default
command to execute, and the `ENTRYPOINT` instruction can include arguments for
the entrypoint command. We could rewrite the `CMD` and `ENTRYPOINT` for
slightly different functionality:

```dockerfile
CMD ["jekyll","serve","-H","0.0.0.0","."]
```

...without an `ENTRYPOINT` instruction would start the built-in Jekyll
webserver by default, but we could also pass a different command to start the
image with instead of `jekyll`.

```dockerfile
ENTRYPOINT ["jekyll","serve","-H","0.0.0.0","."]
```

...without the `CMD` instruction will start the built-in Jekyll webserver with
these exact arguments every time we run the image and essentially disallow
running the image with a different command or set of arguments.

The combination of `CMD` and `ENTRYPOINT` that we use in this Dockerfile
enables a hybrid approach: we start the image with the `jekyll` command each
time, but we allow a different set of arguments for the command at runtime.

Review
------

That's it! Docker uses the twelve instructions in our Dockerfile to build a
simple image capable of running a Jekyll environment for this tutorial. For a
full list of Dockerfile instructions, see the [Official Dockerfile
Reference](https://docs.docker.com/engine/reference/builder/).

Here's the final Dockerfile without annotations:

```dockerfile
FROM ruby:2.3.1-alpine
MAINTAINER Cy Rossignol <cy@rossignols.me>

ENV LANGUAGE=en_US \
    LANG=en_US.UTF-8 \
    LC_ALL=en_US

RUN apk add --no-cache --virtual jekyll-build-deps \
    build-base \
    ruby-dev \
 && apk add --no-cache ruby-io-console
RUN gem update --system && gem install jekyll
RUN apk del jekyll-build-deps libffi-dev openssl-dev yaml-dev zlib-dev \
 && rm /usr/local/bundle/cache/*

RUN mkdir -p /src/docker-quickstart
COPY ../ /src/docker-quickstart
WORKDIR /src/docker-quickstart

EXPOSE 4000

CMD ["serve","-H","0.0.0.0","."]
ENTRYPOINT ["jekyll"]
```

To build this image, execute the following command from the same directory as
this file:

```
docker build -t docker-quickstart .
```

To run the image after building it, execute the following command:

```
docker run -it --rm -p 4000:4000 --name docker-quickstart docker-quickstart
```

Onward
------

Next we'll learn how to push and pull our built images to an image registry:
[Image Registries](../image-registries/)
