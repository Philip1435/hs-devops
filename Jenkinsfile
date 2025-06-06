pipeline {
    agent any

    triggers {
        pollSCM('*/1 * * * *') // Every minute
    }

    stages {
        stage(' Install Dependencies') {
            steps {
                sh "npm install express"
            }
        }
    
        stage('Test') {
            steps {
                sh "node --test"
            }
        }

        stage('Deploy to target') {
            steps {
                withCredentials([sshUserPrivateKey(credentialsId: 'private-key', keyFileVariable: 'ssh_key', usernameVariable: 'ssh_user')]) {
                    sh """
                        mkdir -p ~/.ssh
                        ssh-keyscan -H target >> ~/.ssh/known_hosts

                        scp -i ${ssh_key} index.js ${ssh_user}@target:~
                        scp -i ${ssh_key} index.service ${ssh_user}@target:~
                        scp -i ${ssh_key} -r node_modules ${ssh_user}@target:~
                        ssh -i ${ssh_key} ${ssh_user}@target '
                            sudo systemctl stop index.service 2>/dev/null || true
                            sudo mv /home/laborant/index.js /opt/index.js
                            sudo mv /home/laborant/node_modules /opt/node_modules
                            sudo mv /home/laborant/index.service /etc/systemd/system/index.service

                            sudo systemctl daemon-reload
                            sudo systemctl enable --now index.service
                        '
                    """
                }
            }
        }

        stage('Deploy to docker') {

        }
    }
}