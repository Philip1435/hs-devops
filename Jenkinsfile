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
                sh "docker push ttl.sh/myapp:2h"
                }
            }

        stage('Apply Kubernetes files') {
            steps {
                withKubeConfig([credentialsId: 'k8s-token', serverUrl: 'https://k8s:6443/']) {
                    sh 'kubectl apply -f deployment.yaml'
                }
            }
        }
    }
}

