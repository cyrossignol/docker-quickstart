---
layout: page
title: Introduction
permalink: /tutorial/intro/
---

Docker provides an elegant, flexible, and scalable environment for building
applications and services that run on any machine or operating system that
supports Docker. However, those new to Docker may find the system a bit
overwhelming at the start. The sheer abundance of available information about
Docker can make it difficult for newcomers or developers unfamiliar with
containerization to piece together the important bits needed to begin using
these tools. Of course, as our understanding of Docker grows, this information
becomes invaluable.

This tutorial aims to provide a brief, top-down introduction to the concepts
behind the Docker system. We'll examine the basic components of Docker and how
they fit together.

At the same time, we'll take a bottom-up approach to learning commonly-used
tools and workflows to quickly build working skills that we can immediately
apply in our day-to-day tasks. We'll touch on some best practices and common
mistakes along the way.

Before We Begin
---------------

This tutorial assumes that we:

- can comfortably make our way around a Linux system and execute commands
- know networking basics such as IP addressing and ports
- have a basic understanding of git for the purpose of downloading this tutorial

Structure
---------

We'll use the source code for this tutorial itself to build and run Docker
images and containers. This approach provides context and examples that will
help us understand some concepts in Docker.

Our example application is a basic static website that contains the content in
this tutorial. We'll use Jekyll to build our website inside a Docker container.
Knowledge of Jekyll is not needed to complete the tutorial.

What To Expect
--------------

This guide is not an exhaustive resource for Docker and its related tools. It
simply intends to bootstrap our knowledge to the point where we can perform
fundamental Docker tasks and build applications with Docker using the skills
that we learned.

Depending on your knowledge and your local environment, this tutorial can take
up to a couple of hours to complete. After finishing, we encourage you to
return and use the material contained herein as a resource when needed.

Let's get started: [Docker Overview](../docker-overview/)
