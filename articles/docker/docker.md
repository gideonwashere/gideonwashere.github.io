# Docker

Docker is a platform for developers and sysadmins to build, run and share applications with containers.
Documentation for docker is available at [docs.docker.com](https://docs.docker.com/get-started/).

In general the docker workflow consists of the following:

1. Create and test individual containers fro each component of your application by first creating Docker images.
2. Assemble your containers and supporting infrastructure into a complete application.
3. Test, share, and deploy your complete containerized application.

> Sometimes it could be useful to containerize your development environment as well.

## Installing Docker

Docker can is easily installed by following the docs. To test the installation is working check `docker --version` and execute `docker run hello-world`.

## Basic commands

* `docker --version` for version information
* `docker run` to run a command in a new container
* `docker image` to manage images
* `docker container` to manage containers

## Dockerfile

The first step to creating a Docker image is makeing the Dockerfile.
A Dockerfile is like a recipe for building the image.
Full Dockerfile documentation is available [here](https://docs.docker.com/engine/reference/builder/).

Example Dockerfile from tutorial:
```
# Use the official image as a parent image
FROM node:current-slim

# Set the working directory
WORKDIR /usr/src/app

# Copy the file from your host to your current location
COPY package.json .

# Run the command inside your image filesystem
RUN npm install

# Inform Docker that the container is listening on the specified port at runtime.
EXPOSE 8080

# Run the specified command within the container.
CMD [ "npm", "start" ]

# Copy the rest of your app's source code from your host to your image filesystem.
COPY . .
```


* Start `FROM` the pre-existing `node:current-slim` image. This is an *official image*, built by the node.js vendors and validated by Docker to be a high-quality image containing the Node.js Long Term Support (LTS) interpreter and basic dependencies.
* Use `WORKDIR` to specify that all subsequent actions should be taken from the directory `/usr/src/app` in your image filesystem (never the host’s filesystem).
* `COPY` the file `package.json` from your host to the present location (`.`) in your image (so in this case, to `/usr/src/app/package.json`)
* `RUN` the command `npm install` inside your image filesystem (which will read `package.json` to determine your app’s node dependencies, and install them)
* The `EXPOSE 8080` informs Docker that the container is listening on port 8080 at runtime.
* The `CMD` directive is the first example of specifying some metadata in your image that describes how to run a container based on this image. In this case, it’s saying that the containerized process that this image is meant to support is `npm start`.
* `COPY` in the rest of your app’s source code from your host to your image filesystem.

> Although these can be defined in any order, best practice is to organize your Dockerfile in the above order.

## Building and running an image

Once you have a Dockerfile for you project you can build the image. Ensure you're in the same directory as your Dockerfile and run `docker image build -t <name> .`

To start a container based on the new image use `docker container run`. Parameters defined in the Dockerfile under `CMD` will automatically be executed at start.

Example:
```
docker image build -t bulletinboard:1.0 .

docker container run --publish 8000:8080 --detach --name bb bulletinboard:1.0

docker container rm --force bb
```

* `--publish` asks Docker to forward traffic incoming on the host’s port 8000, to the container’s port 8080. Containers have their own private set of ports, so if you want to reach one from the network, you have to forward traffic to it in this way. Otherwise, firewall rules will prevent all network traffic from reaching your container, as a default security posture.
* `--detach` asks Docker to run this container in the background.
* `--name` specifies a name with which you can refer to your container in subsequent commands, in this case `bb`.
* The `--force` option removes the running container.

## Dockerhub

You can use Dockerhub to share images if you want. Check the docs [here](https://docs.docker.com/get-started/part3/).

## Sharing Docker image without Dockerhub

1. Locally, save docker image as a `.tar`.

`docker save -o <outfile.tar> <image-name>`

2. Locally, use `scp` to transfer `.tar` to remote.
3. On remote server, load image into docker.

`docker load -i <docker-image.tar>`


## Glossary
