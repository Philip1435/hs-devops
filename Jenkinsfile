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
                withCredentials([sshUserPrivateKey(credentialsId: 'private-key', keyFileVariable: 'ssh_key', usernameVariable: 'ssh_user')]) {

                sh """
                chmod +x main
                ANSIBLE_HOST_KEY_CHECKING=False ansible-playbook --inventory hosts.ini playbook.yml --key-file=${ssh_key}
                """

                }
            }
        }
    }
}
