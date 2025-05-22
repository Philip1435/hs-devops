pipeline {
    agent any

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

        stage('Deploy') {
            steps {
                sh """
                mkdir -p ~/.ssh
                ssh-keyscan -H target >> ~/.ssh/known_hosts
                scp main laborant@target:~
                """
            }
        }
    }
}
