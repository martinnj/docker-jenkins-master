node ("docker") {
    VERSION_STRING="$MAJOR_VERSION.$MINOR_VERSION.$BUILD_NUMBER"
    def image = null
    stage("Git Pull") {
        git credentialsId: 'github_pk', url: "git@github.com:martinnj/docker-jenkins-master.git", branch: '$BRANCH'
    }
    stage("Build") {
        image = docker.build("jenkins-master:$VERSION_STRING", "--no-cache .")
    }
    stage("Push") {
        docker.withRegistry("$REGISTRY_URL") {
            image.push()
            image.push("latest")
        }
    }
    stage("Tag") {
        sshagent(['github_pk']) {
            sh "git tag -a v$VERSION_STRING -m \"Tagged by $BUILD_URL\""
            sh "git push --tags"
        }
    }
    stage("Clean") {
        cleanWs()
    }
}
