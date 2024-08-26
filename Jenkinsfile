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
        DOCKER_REGISTRY_PORTAL = 'harbor-portal.common.svc.cluster.local:80'
        DOCKER_REGISTRY_CORE = 'harbor-core.common.svc.cluster.local:80'
        IMAGE_NAME = 'student/front-end-haho'
        HARBOR_REGISTRY = 'harbor.okestro.io/front-end-haho'
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
                    sh '''
                        # 이미지 빌드 및 태그
                        podman build -t $DOCKER_REGISTRY_CORE/$IMAGE_NAME:$TAG_NAME -f ./Dockerfile .
                        podman tag $DOCKER_REGISTRY_CORE/$IMAGE_NAME:$TAG_NAME $HARBOR_REGISTRY/$IMAGE_NAME:$TAG_NAME
                    '''
                }
            }
        }

        stage('Push Docker Image to Harbor') {
            steps {
                container('podman') {
                    sh '''
                        podman login $DOCKER_REGISTRY_PORTAL -u $HARBOR_USERNAME -p $HARBOR_PASSWORD --tls-verify=false
                        podman push $HARBOR_REGISTRY/$IMAGE_NAME:$TAG_NAME --tls-verify=false
                    '''
                }
            }
        }

        stage('Tag & Push Latest Docker Image') {
            steps {
                container('podman') {
                    sh '''
                        podman tag $DOCKER_REGISTRY_CORE/$IMAGE_NAME:$TAG_NAME $HARBOR_REGISTRY/$IMAGE_NAME:$TAG_NAME
                        podman push $HARBOR_REGISTRY/$IMAGE_NAME:$TAG_NAME --tls-verify=false
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
