pipeline {
    agent any

    environment {
        GIT_REPO = 'http://gitea.okestro.io/student/front-end-haho.git' // Gitea Repository URL
        DOCKER_REGISTRY = 'harbor.okestro.io' // Harbor Registry URL
        IMAGE_NAME = 'student/front-end-haho' // 이미지 이름 (Harbor에 저장될 이름)
        KUBE_NAMESPACE = 'haho' // Kubernetes Namespace
    }

    stages {
        stage('Clone Repository') {
            steps {
                git branch: 'main', url: "${GIT_REPO}"
            }
        }

        stage('Build Docker Image') {
            steps {
                script {
                    dockerImage = docker.build("${DOCKER_REGISTRY}/${IMAGE_NAME}:${env.BUILD_ID}")
                }
            }
        }

        stage('Push Docker Image to Harbor') {
            steps {
                script {
                    docker.withRegistry("https://${DOCKER_REGISTRY}", 'harbor-credentials') {
                        dockerImage.push()
                    }
                }
            }
        }

        stage('Deploy to Kubernetes via ArgoCD') {
            steps {
                script {
                    sh """
                    argocd app set <your-argo-app-name> --values image.tag=${env.BUILD_ID} --sync
                    """
                }
            }
        }
    }

    post {
        always {
            cleanWs()
        }
        success {
            echo 'Deployment completed successfully.'
        }
        failure {
            echo 'Deployment failed.'
        }
    }
}
