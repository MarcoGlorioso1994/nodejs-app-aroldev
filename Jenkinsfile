podTemplate(yaml: '''
  apiVersion: v1
  kind: Pod
  metadata:
    name: dockercontainer
  spec:
    containers:
    - image: docker:24.0.0-rc.1-dind
      name: dockercontainer
      securityContext:
        privileged: true # this should do the trick
''') {
    
    node(POD_LABEL) {
       try {
            stage('Git Clone') {
                echo "The Build Number is ${env.BUILD_NUMBER}"
                git branch: 'main', credentialsId: 'github', url: 'https://github.com/MarcoGlorioso1994/nodejs-app-aroldev.git'
            }
    
            stage('Check Docker socket') {
                container('dockercontainer') {
                    sh """
                    sleep 3
                    docker version
                    """
                }
            }
    
            stage('Build Docker image') {
                container('dockercontainer') {
                    sh """
                    docker build -t marcoglorioso/nodejs-app-aroldev:${env.BUILD_NUMBER} .
                    docker tag marcoglorioso/nodejs-app-aroldev:${env.BUILD_NUMBER} marcoglorioso/nodejs-app-aroldev:latest
                    """
                }
            }
    
            stage('Login to DockerHub') {
                container('dockercontainer') {
                    sh 'cat my_password.txt | docker login --username marcoglorioso --password-stdin'
                }
            }
    
            stage('Push Docker Image') {
                container('dockercontainer') {
                    sh """
                    docker push marcoglorioso/nodejs-app-aroldev:${env.BUILD_NUMBER}
                    docker push marcoglorioso/nodejs-app-aroldev:latest
                    """
                }
            }
            
            stage('Clean Workspace') {
                cleanWs()
            }
            
            stage('Update values.yaml Chart') {
                git branch: 'main', credentialsId: 'github', url: 'https://github.com/MarcoGlorioso1994/nodejs-app-aroldev-infra.git'
                // Update the image tag in values.yaml (assumes image: <tag> format)
                sh """
                sed -i 's/tag:.*/tag: \\"${env.BUILD_NUMBER}\\"/' values.yaml
                git config --global user.email "marcoglorioso1594@gmail.com"
                git config --global user.name "Marco Glorioso"
                git add values.yaml
                git commit -m "Update image tag to ${env.BUILD_NUMBER}"
                """
            }
            
            stage('Git Push Infra') {
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
        } catch (Exception e) {
            echo "An error occurred: ${e.getMessage()}"
            currentBuild.result = 'FAILURE'
        } finally {
            echo "Cleaning up..."
            cleanWs()
        }
    }
}
