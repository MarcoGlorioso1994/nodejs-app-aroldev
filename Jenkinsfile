pipeline {
    agent any

    environment {
        DOCKER_CREDENTIALS_ID = 'dockerhub'
        DOCKER_IMAGE = 'marcoglorioso/nodejs-app-aroldev:latest'
    }

    stages {
        stage('Clone Repository') {
            steps {
                git 'https://github.com/MarcoGlorioso1994/nodejs-app-aroldev.git'
            }
        }
        stage('Build Docker Image') {
            steps {
                script {
                    docker.build("${DOCKER_IMAGE}")
                }
            }
        }
        stage('Push to DockerHub') {
            steps {
                script {
                    docker.withRegistry('https://registry.hub.docker.com', "${DOCKER_CREDENTIALS_ID}") {
                        docker.image("${DOCKER_IMAGE}").push()
                    }
                }
            }
        }
    }
}