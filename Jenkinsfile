node ("docker") {
    VERSION_STRING="$MAJOR_VERSION.$MINOR_VERSION.$BUILD_NUMBER"
    stage("Git Pull") {
        git credentialsId: 'github_pk', url: "git@github.com:martinnj/docker-jenkins-master.git", branch: '$BRANCH'
    }
    stage("Build") {
        docker.build("jenkins-master:$VERSION_STRING")
    }
    stage("Push") {
        docker.withRegistry("$REGISTRY_URL") {
            docker.image("jenkins-master:$VERSION_STRING").push("latest")
        }
    }
    stage("Tag") {
        sshagent(['github_pk']) {
            sh "git tag -a v$VERSION_STRING -m \"Tagged by $BUILD_URL\""
            sh "git push --tags"
        }
    }
    stage("Clean") {
        // It might be a good idea to remove the image from this machines
        // Docker instance if it's not going to run here anyway.
        cleanWs()
    }
}
