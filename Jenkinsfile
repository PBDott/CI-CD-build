pipeline {
    agent any

    environment {
        GIT_REPO = 'http://gitea-http.common.svc.cluster.local:3000/student/front-end-haho.git'
        DOCKER_REGISTRY = 'harbor.okestro.io'
        IMAGE_NAME = 'student/front-end-haho'
        KUBE_NAMESPACE = 'haho'
        ARGOCD_APP_NAME = 'your-argo-app-name'  // 실제 ArgoCD 애플리케이션 이름으로 변경 필요
        HARBOR_USERNAME = 'student'  // Harbor 사용자 이름
        HARBOR_PASSWORD = 'Okestro2018!'  // Harbor 비밀번호
    }

    stages {
        stage('Clone Repository') {
            steps {
                git branch: 'main', url: "${GIT_REPO}"
            }
        }

        stage('Build Podman Image') {
            steps {
                script {
                    sh '''
                    #!/bin/bash
                    podman build -t ${DOCKER_REGISTRY}/${IMAGE_NAME}:${BUILD_ID} .
                    '''
                }
            }
        }

        stage('Push Podman Image to Harbor') {
            steps {
                script {
                    sh 'podman login -u ${HARBOR_USERNAME} -p ${HARBOR_PASSWORD} ${DOCKER_REGISTRY}'
                    sh 'podman push ${DOCKER_REGISTRY}/${IMAGE_NAME}:${env.BUILD_ID}'
                }
            }
        }

        stage('Deploy to Kubernetes via ArgoCD') {
            steps {
                script {
                    sh """
                    argocd app set ${ARGOCD_APP_NAME} --values image.tag=${env.BUILD_ID} --sync
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
