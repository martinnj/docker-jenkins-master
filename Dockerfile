FROM jenkins/jenkins:alpine

# The first tasks are done as root.
USER root

# Install git and curl, we'll prolly need them.
RUN apk update && apk add --update --no-cache curl git

# Install and configure Docker.
# gid here should match the gid of the hosts docker-group.
RUN addgroup -g 998 docker
RUN apk add --update --no-cache docker
RUN adduser jenkins docker

# Drop down to normal privileges.
USER jenkins

# Utility plugins.
RUN jenkins-plugin-cli --plugins \
    cloudbees-folder \
    timestamper \
    ws-cleanup

# SSH plugins.
RUN jenkins-plugin-cli --plugins \
    ssh-agent

# Versioning plugins.
RUN jenkins-plugin-cli --plugins \
    git

# Pipeline plugins.
RUN jenkins-plugin-cli --plugins \
    workflow-aggregator \
    pipeline-stage-view \
    blueocean

# Python plugins
RUN jenkins-plugin-cli --plugins \
    pyenv-pipeline

# Docker image creation.
RUN jenkins-plugin-cli --plugins \
    docker-plugin \
    docker-workflow
