pipeline {
    agent any

    triggers {
        pollSCM('*/1 * * * *') // Every minute
    }

    stages {
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