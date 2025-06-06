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

        stage('Docker Build and Push') {
            steps {
                sh "docker build . --tag ttl.sh/myapp:2h"
                sh "docker push ttl.sh/myapp:2h"
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
            steps {
                withCredentials([sshUserPrivateKey(credentialsId: 'private-key', keyFileVariable: 'ssh_key', usernameVariable: 'ssh_user')]) {
                    sh """
                    mkdir -p ~/.ssh
                    ssh-keyscan -H docker >> ~/.ssh/known_hosts
                    ssh -i ${ssh_key} ${ssh_user}@docker '
                        docker stop myapp || true
                        docker rm myapp || true
                        docker run -d --name myapp -p 4444:4444 ttl.sh/myapp:2h
                    '
                    """
                }
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