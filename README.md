# Docker Jenkins Master

Dockerized Jenkins master for home use.

You can handbuild the image if you feel like, but the Jenkins pipeline file
requires a little setup, the following environment variables must be available:

- `$MAJOR_VERSION`
- `$MINOR_VERSION`
- `$BRANCH`
- `$REGISTRY_URL`

Or you can just replace them in-file.

You will also need to set the git credentials for the Jenkins user in the
container, something to the tune of:

- `$ git config --global user.email "agent@jenkins.local"`
- `$ git config --global user.name "Jenkins Agent"`
