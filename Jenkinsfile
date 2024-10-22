pipeline {
    agent { label 'docker-agent'}
    stages {
        stage('Git Clone') {
            steps { 
                script {
                    sh "echo \"The Build Number is ${env.BUILD_NUMBER}\""
                    git branch: 'main', credentialsId: 'github', url: 'https://github.com/MarcoGlorioso1994/nodejs-app-aroldev.git'
                }
            }
        }

        stage('Check Docker socket') {
            steps { 
                container('docker') {
                    sh """
                    sleep 3
                    docker version
                    """
                }
            }
        }

        stage('Build Docker image') {
            steps { 
                container('docker') {
                    sh """
                    docker build -t marcoglorioso/nodejs-app-aroldev:${env.BUILD_NUMBER} .
                    docker tag marcoglorioso/nodejs-app-aroldev:${env.BUILD_NUMBER} marcoglorioso/nodejs-app-aroldev:latest
                    """
                }
            }
        }

        stage('Login to DockerHub') {
            steps { 
                container('docker') {
                    sh 'cat my_password.txt | docker login --username marcoglorioso --password-stdin'
                }
            }
        }

        stage('Push Docker Image') {
            steps { 
                container('docker') {
                    sh """
                    docker push marcoglorioso/nodejs-app-aroldev:${env.BUILD_NUMBER}
                    docker push marcoglorioso/nodejs-app-aroldev:latest
                    """
                }
            }
        }
        
        stage('Clean Workspace') {
            steps { 
                cleanWs()
            }
        }
        
        stage('Update values.yaml Chart') {
            steps {
                script {
                    // Update the image tag in values.yaml (assumes image: <tag> format)
                    sh """
                    git clone https://github.com/MarcoGlorioso1994/nodejs-app-aroldev-infra.git .
                    sed -i 's/tag:.*/tag: \\"${env.BUILD_NUMBER}\\"/' values.yaml
                    git config --global user.email "marcoglorioso1594@gmail.com"
                    git config --global user.name "Marco Glorioso"
                    git add values.yaml
                    git commit -m "Update image tag to ${env.BUILD_NUMBER}"
                    """
                }
            }
        }
        
        stage('Git Push Infra') {
            steps { 
                withCredentials([
                    gitUsernamePassword(credentialsId: 'github', gitToolName: 'Default')
                ]) {
                    sh """
                    git branch -M main
                    git remote set-url origin https://github.com/MarcoGlorioso1994/nodejs-app-aroldev-infra.git
                    git push -u origin main
                    """
                }
            }
        }      
    }
    post {
        always {
            echo 'Cleaning workspace...'
            cleanWs()  // This is the step to clean the workspace
        }
    }
}