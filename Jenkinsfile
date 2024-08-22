pipeline {
    agent {
        kubernetes {
            inheritFrom 'default'
            defaultContainer 'jnlp'
            containerTemplate {
                name 'podman'
                image 'quay.io/podman/stable:latest'
                ttyEnabled true
                command 'cat'
                privileged true
            }
        }
    }
    environment {
        GIT_REPO = 'http://gitea-http.common.svc.cluster.local:3000/student/front-end-haho.git'
        DOCKER_REGISTRY = 'harbor-registry.common.svc.cluster.local:5000'
        IMAGE_NAME = 'student/front-end-haho'
        HARBOR_USERNAME = 'student'
        HARBOR_PASSWORD = 'Okestro2018!'
        BUILD_NUMBER = "${env.BUILD_NUMBER}"
        TAG_NAME = "SNAPSHOT-${BUILD_NUMBER}"
    }
    stages {
        stage('Clone Repository') {
            steps {
                container('git') {
                    git branch: 'main', url: "${GIT_REPO}"
                }
            }
        }

        stage('Build Docker Image') {
            steps {
                container('podman') {
                    sh 'podman build -t $DOCKER_REGISTRY/$IMAGE_NAME:$TAG_NAME -f ./Dockerfile .'
                }
            }
        }

        stage('Push Docker Image to Harbor') {
            steps {
                container('podman') {
                    sh '''
                        echo 'Okestro2018!' | podman login --tls-verify=false http://harbor-registry.common.svc.cluster.local:5000 -u student --password-stdin
                        podman push --tls-verify=false $DOCKER_REGISTRY/$IMAGE_NAME:$TAG_NAME
                    '''
                }
            }
        }

        stage('Tag & Push Latest Docker Image') {
            steps {
                container('podman') {
                    sh '''
                        podman tag $DOCKER_REGISTRY/$IMAGE_NAME:$TAG_NAME $DOCKER_REGISTRY/$IMAGE_NAME:latest
                        podman push --tls-verify=false $DOCKER_REGISTRY/$IMAGE_NAME:latest
                    '''
                }
            }
        }
    }

    post {
        success {
            echo 'Build and push to Harbor successful'
        }
        failure {
            echo 'Build or push failed'
        }
    }
}
