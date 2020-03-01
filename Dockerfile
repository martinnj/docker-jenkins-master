FROM jenkins/jenkins:alpine

# The first tasks are done as root.
USER root

# Install git and curl, we'll prolly need them.
RUN apk update && apk add --update --no-cache curl git

# Install and configure Docker.
# gid here should match the gid of the hosts docker-group.
RUN addgroup -g 1001 docker
RUN apk add --update --no-cache docker
RUN adduser jenkins docker

# Drop down to normal privileges.
USER jenkins

# Utility plugins.
RUN /usr/local/bin/install-plugins.sh cloudbees-folder timestamper ws-cleanup

# SSH plugins.
RUN /usr/local/bin/install-plugins.sh ssh-agent

# Versioning plugins.
RUN /usr/local/bin/install-plugins.sh git

# Pipeline plugins.
RUN /usr/local/bin/install-plugins.sh workflow-aggregator pipeline-stage-view blueocean

# Python plugins
RUN /usr/local/bin/install-plugins.sh pyenv-pipeline

# Docker image creation.
RUN /usr/local/bin/install-plugins.sh docker-plugin docker-workflow

# Attempt to set git credentials.
RUN git config --global user.email "agent@jenkins.local" \
 && git config --global user.name "Jenkins Agent"
