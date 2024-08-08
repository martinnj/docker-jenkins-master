####################################################################################################
###                                                                                              ###
###                                           ARGUMENTS                                          ###
###                                                                                              ###
####################################################################################################


# None yet.


####################################################################################################
###                                                                                              ###
###                                       BASE IMAGE STEPS                                       ###
###                                                                                              ###
####################################################################################################

# Should be kept around the latest LTS release.
FROM jenkins/jenkins:2.462.1-alpine


################################################################################
###                                                                          ###
###                             System Level Prep                            ###
###                                                                          ###
################################################################################


# The first tasks are done as root.
USER root

# Install git and curl, we'll prolly need them.
RUN apk update && apk add --update --no-cache curl git

# Install and configure Docker.
# gid here should match the gid of the hosts docker-group.
RUN addgroup -g 998 docker
RUN apk add --update --no-cache docker
RUN adduser jenkins docker


################################################################################
###                                                                          ###
###                             Jenkins User Prep                            ###
###                                                                          ###
################################################################################


# Drop down to normal privileges.
USER jenkins


################################################################################
###                                                                          ###
###                           Jenkins Plugins Prep                           ###
###                                                                          ###
################################################################################


# Utility plugins.
RUN jenkins-plugin-cli --plugins \
    cloudbees-folder \
    dark-theme \
    ws-cleanup

# SSH plugins.
RUN jenkins-plugin-cli --plugins \
    ssh-agent

# Versioning plugins.
RUN jenkins-plugin-cli --plugins \
    git

# Pipeline plugins.
RUN jenkins-plugin-cli --plugins \
    blueocean \
    pipeline-stage-view \
    workflow-aggregator

# Python plugins.
RUN jenkins-plugin-cli --plugins \
    pyenv-pipeline

# Docker image creation.
RUN jenkins-plugin-cli --plugins \
    docker-plugin \
    docker-workflow

# Unit-test/lint/reporting plugins.
RUN jenkins-plugin-cli --plugins \
    coverage \
    warnings-ng \
    xunit

# Add the JCasC plugin
RUN jenkins-plugin-cli --plugins \
    configuration-as-code


################################################################################
###                                                                          ###
###                          Jenkins  Configuration                          ###
###                                                                          ###
################################################################################


# Copy the JCasC configuration file into the container
COPY jenkins.yaml /etc/martin_jenkins/casc_configs/jenkins.yaml


# Set the environment variable to point to the JCasC configuration file
ENV CASC_JENKINS_CONFIG=/etc/martin_jenkins/casc_configs/jenkins.yaml


################################################################################
###                                                                          ###
###                            Git  Configuration                            ###
###                                                                          ###
################################################################################


# Attempt to set the git config so we can push tags.
RUN git config --global user.email "hello@martinnj.dk"
RUN git config --global user.name "Docker Jenkins"
