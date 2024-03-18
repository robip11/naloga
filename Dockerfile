# # syntax=docker/dockerfile:1

# # Comments are provided throughout this file to help you get started.
# # If you need more help, visit the Dockerfile reference guide at
# # https://docs.docker.com/go/dockerfile-reference/

# # Want to help us make this template better? Share your feedback here: https://forms.gle/ybq9Krt8jtBL3iCk7

# ################################################################################
# # Pick a base image to serve as the foundation for the other build stages in
# # this file.
# #
# # For illustrative purposes, the following FROM command
# # is using the alpine image (see https://hub.docker.com/_/alpine).
# # By specifying the "latest" tag, it will also use whatever happens to be the
# # most recent version of that image when you build your Dockerfile.
# # If reproducability is important, consider using a versioned tag
# # (e.g., alpine:3.17.2) or SHA (e.g., alpine@sha256:c41ab5c992deb4fe7e5da09f67a8804a46bd0592bfdf0b1847dde0e0889d2bff).
# FROM alpine:latest as base

# ################################################################################
# # Create a stage for building/compiling the application.
# #
# # The following commands will leverage the "base" stage above to generate
# # a "hello world" script and make it executable, but for a real application, you
# # would issue a RUN command for your application's build process to generate the
# # executable. For language-specific examples, take a look at the Dockerfiles in
# # the Awesome Compose repository: https://github.com/docker/awesome-compose
# FROM base as build
# RUN echo -e '#!/bin/sh\n\
# echo Hello world from $(whoami)! In order to get your application running in a container, take a look at the comments in the Dockerfile to get started.'\
# > /bin/hello.sh
# RUN chmod +x /bin/hello.sh

# ################################################################################
# # Create a final stage for running your application.
# #
# # The following commands copy the output from the "build" stage above and tell
# # the container runtime to execute it when the image is run. Ideally this stage
# # contains the minimal runtime dependencies for the application as to produce
# # the smallest image possible. This often means using a different and smaller
# # image than the one used for building the application, but for illustrative
# # purposes the "base" image is used here.
# FROM base AS final

# # Create a non-privileged user that the app will run under.
# # See https://docs.docker.com/go/dockerfile-user-best-practices/
# ARG UID=10001
# RUN adduser \
#     --disabled-password \
#     --gecos "" \
#     --home "/nonexistent" \
#     --shell "/sbin/nologin" \
#     --no-create-home \
#     --uid "${UID}" \
#     appuser
# USER appuser

# # Copy the executable from the "build" stage.
# COPY --from=build /bin/hello.sh /bin/

# # What the container should run when it is started.
# ENTRYPOINT [ "/bin/hello.sh" ]



# # Stage 1: Build the Flutter application
# FROM ubuntu:20.04 AS builder

# # Set environment variables
# ENV DEBIAN_FRONTEND=noninteractive \
#     TZ=UTC \
#     LANG=C.UTF-8 \
#     LC_ALL=C.UTF-8 \
#     PATH=/usr/lib/dart/bin:/flutter/bin/cache/dart-sdk/bin:$PATH \
#     FLUTTER_VERSION=2.10.2-stable

# # Install necessary dependencies
# RUN apt-get update && apt-get install -y \
#     curl \
#     git \
#     unzip \
#     xz-utils \
#     zip \
#     libglu1-mesa \
#     && rm -rf /var/lib/apt/lists/*

# # Install Flutter SDK
# RUN git clone --branch $FLUTTER_VERSION --depth 1 https://github.com/flutter/flutter.git /flutter

# # Add Flutter to PATH
# ENV PATH=/flutter/bin:$PATH

# # Accept Flutter licenses
# RUN flutter doctor -v

# # Copy the Flutter application source code to the container
# WORKDIR /app
# COPY . .

# # Build the Flutter application
# RUN flutter build apk --release

# # Stage 2: Create the production image
# FROM nginx:latest

# # Copy the built Flutter application to nginx web root
# COPY --from=builder /app/build/app/outputs/flutter-apk/app-release.apk /usr/share/nginx/html/

# # Expose port 80
# EXPOSE 80

# # Start nginx
# CMD ["nginx", "-g", "daemon off;"]






# FROM ubuntu:18.04

# # Prerequisites
# RUN apt update && apt install -y curl git unzip xz-utils zip libglu1-mesa openjdk-8-jdk wget

# # Set up new user
# RUN useradd -ms /bin/bash developer
# USER developer
# WORKDIR /app/

# # Prepare Android directories and system variables
# RUN mkdir -p Android/sdk
# ENV ANDROID_SDK_ROOT /app/Android/sdk
# RUN mkdir -p .android && touch .android/repositories.cfg

# # Set up Android SDK
# RUN wget -O sdk-tools.zip https://dl.google.com/android/repository/sdk-tools-linux-4333796.zip
# RUN unzip sdk-tools.zip && rm sdk-tools.zip
# RUN mv tools Android/sdk/tools
# RUN cd Android/sdk/tools/bin && yes | ./sdkmanager --licenses
# RUN cd Android/sdk/tools/bin && ./sdkmanager "build-tools;29.0.2" "platform-tools" "platforms;android-29" "sources;android-29"
# ENV PATH "$PATH:/app/Android/sdk/platform-tools"

# # Download Flutter SDK
# RUN git clone https://github.com/flutter/flutter.git
# ENV PATH "$PATH:/app/flutter/bin"

# # Run basic check to download Dark SDK
# RUN flutter doctor

# # Enable flutter web
# RUN flutter channel master
# RUN flutter upgrade
# RUN flutter config --enable-web

# # Copy files to container and build
# RUN mkdir /app/
# COPY . /app/
# WORKDIR /app/
# RUN flutter build web

# # Record the exposed port
# EXPOSE 9000

# # make server startup script executable and start the web server
# RUN ["chmod", "+x", "/app/server/server.sh"]

# ENTRYPOINT [ "/app/server/server.sh"]


# Build stage
FROM ubuntu:20.04 AS build

# Set the working directory
WORKDIR /app

# Install necessary dependencies
RUN apt-get update && apt-get install -y \
    git \
    unzip \
    xz-utils \
    curl \
    wget \
    libglu1-mesa \
    lib32stdc++6 \
    libstdc++6 \
    && rm -rf /var/lib/apt/lists/*

# Download and extract Flutter SDK
RUN wget https://storage.googleapis.com/flutter_infra_release/releases/stable/linux/flutter_linux_3.19.3-stable.tar.xz
RUN tar xf flutter_linux_3.19.3-stable.tar.xz

# Add Flutter SDK to PATH
ENV PATH="/app/flutter/bin:${PATH}"

# Copy pubspec files
COPY pubspec.yaml .
COPY pubspec.lock .

# Run flutter pub get to fetch dependencies
RUN flutter pub get

# Copy the rest of the project files
COPY . .

# Build the Flutter project for web
RUN flutter build web

# Production stage
FROM nginx:alpine

# Copy the built web files to nginx
COPY --from=build /app/build/web /usr/share/nginx/html

# Expose port 80
EXPOSE 80

# Copy entrypoint script into the image
COPY docker-entrypoint.sh /usr/local/bin/

# Make the entrypoint script executable
RUN chmod +x /usr/local/bin/docker-entrypoint.sh

# Set the entrypoint script as the entrypoint of the image
ENTRYPOINT ["/usr/local/bin/docker-entrypoint.sh"]