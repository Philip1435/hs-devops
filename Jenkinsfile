pipeline {
    agent any

    triggers {
        pollSCM('*/1 * * * *') // Every minute
    }

    stages {
        stage('Install Nodejs') {
            steps {
                sh """
                curl -fsSL https://deb.nodesource.com/setup_22.x -o nodesource_setup.sh
                bash nodesource_setup.sh
                apt-get install -y nodejs
                """
            }
        }

        stage(' Install Dependencies') {
            steps {
                sh """
                npm install express
                """
            }
        }
        stage('Test') {
            steps {
                sh "node --test"
            }
        }

        stage('Run') {
            steps {
                sh "node index.js"
            }
        }
    }
}