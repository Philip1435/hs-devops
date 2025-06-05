pipeline {
    agent any

    environment {
        DOCKER_IMAGE = 'ttl.sh/myapp:2h'
        CONTAINER_NAME = 'myapp'
        HOST_PORT = '4444'
        CONTAINER_PORT = '4444'
        AWS_USER = 'ec2-user'
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
                sh "docker push ttl.sh/myapp:2h"
                }
            }

        stage('Apply terraform') {
            steps {
                sh "terraform init"
                sh "terraform apply"
            }
        }

        stage('Deploy to cloud instance') {
            steps {
                withCredentials([sshUserPrivateKey(credentialsId: 'private-key', keyFileVariable: 'ssh_key', usernameVariable: 'ssh_user')]) {
                    sh """
                    chmod +x main
                    mkdir -p ~/.ssh
                    export instance_ip="${{ terraform output instance_ip | tr -d '"' }}

                    ssh-keyscan -H docker >> ~/.ssh/known_hosts
                    ssh -i ${ssh_key} ${AWS_USER}@${instance_ip} 'docker stop ${CONTAINER_NAME} || true'
                    ssh -i ${ssh_key} ${AWS_USER}@${instance_ip} 'docker rm ${CONTAINER_NAME} || true'
                    ssh -i ${ssh_key} ${AWS_USER}@${instance_ip} 'docker run -d --name ${CONTAINER_NAME} -p ${HOST_PORT}:${CONTAINER_PORT} ${DOCKER_IMAGE}'
                    """
            }
        }
    }
}
}

