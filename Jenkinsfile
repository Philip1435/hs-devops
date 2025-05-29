pipeline {
    agent any

    environment {
        DOCKER_IMAGE = 'ttl.sh/myapp:2h'
        CONTAINER_NAME = 'myapp'
        HOST_PORT = '4444'
        CONTAINER_PORT = '4444'
    }

    tools {
       go "1.24.1"
    }

    triggers {
        pollSCM('*/1 * * * *') // Every minute
    }

    stages {
        stage('Test') {
            steps {
                sh "go test ./..."
            }
        }

        stage('Build') {
            steps {
                sh "go build main.go"
            }
        }

        stage('Docker Build and Push') {
            steps {
                sh "docker build . --tag ttl.sh/myapp:2h"
                sh "docker push"
                }
            }

        stage('Docker Deploy') {
            steps {
                withCredentials([sshUserPrivateKey(credentialsId: 'private-key', keyFileVariable: 'ssh_key', usernameVariable: 'ssh_user')]) {
                    sh """
                    chmod +x main
                    mkdir -p ~/.ssh
                    ssh-keyscan -H target >> ~/.ssh/known_hosts
                    ssh -i ${ssh_key} laborant@target 'docker pull ${DOCKER_IMAGE}'
                    ssh -i ${ssh_key} laborant@target 'docker run -d --name ${CONTAINER_NAME} -p ${HOST_PORT}:${CONTAINER_PORT} ${DOCKER_IMAGE}'
                    """
            }
        }
    }
}
}

