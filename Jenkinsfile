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
    stage('Build Docker image') {
      git branch: 'main', credentialsId: 'github', url: 'https://github.com/MarcoGlorioso1994/nodejs-app-aroldev.git'
      container('dockercontainer') {
        sh 'docker version'
        sh 'docker build -t marcoglorioso/nodejs-app-aroldev .'
        sh 'cat my_password.txt | docker login --username marcoglorioso --password-stdin'
        sh 'docker push marcoglorioso/nodejs-app-aroldev'
      }
    }
  }
}
