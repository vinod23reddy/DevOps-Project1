pipeline {
    agent {
        label 'Jenkins-Agent'
    }
    environment {
        DOCKER_USERNAME = 'vinod23reddy'
        IMAGE_NAME      = 'food-zone-app'
        IMAGE_TAG       = "${env.BUILD_NUMBER}"
        DOCKER_CREDS    = credentials('Dockerhub')
    }
    stages {
        stage('Clean Workspace') {
            steps {
                cleanWs()
            }
        }
        stage('Checkout SCM') {
            steps {
                git url: 'https://github.com/vinod23reddy/FoodZone.git', branch: 'main', credentialsId: 'github'
            }
        }
        stage('Install Dependencies') {
            steps {
                sh 'npm install'
            }
        }
        stage('SonarQube Analysis') {
            steps {
                withSonarQubeEnv('sonarqube-server') {
                    sh '''
                        sonar-scanner \
                          -Dsonar.projectKey=food-zone-app \
                          -Dsonar.sources=src \
                          -Dsonar.host.url=$SONAR_HOST_URL \
                          -Dsonar.login=$SONAR_AUTH_TOKEN
                    '''
                }
            }
        }
        stage('Quality Gate') {
            steps {
                waitForQualityGate abortPipeline: true
            }
        }
        stage('Fetch Dockerfile') {
            steps {
                sh 'curl -o Dockerfile https://raw.githubusercontent.com/vinod23reddy/CI-CD/master/Dockerfile'
            }
        }
        stage('Docker Build') {
            steps {
                sh 'docker build -t ${DOCKER_USERNAME}/${IMAGE_NAME}:${IMAGE_TAG} .'
                sh 'docker tag ${DOCKER_USERNAME}/${IMAGE_NAME}:${IMAGE_TAG} ${DOCKER_USERNAME}/${IMAGE_NAME}:latest'
            }
        }
        stage('Trivy Scan') {
            steps {
                sh 'trivy image ${DOCKER_USERNAME}/${IMAGE_NAME}:${IMAGE_TAG}'
            }
        }
        stage('Docker Push') {
            steps {
                sh 'echo $DOCKER_CREDS_PSW | docker login -u $DOCKER_CREDS_USR --password-stdin'
                sh 'docker push ${DOCKER_USERNAME}/${IMAGE_NAME}:${IMAGE_TAG}'
                sh 'docker push ${DOCKER_USERNAME}/${IMAGE_NAME}:latest'
            }
        }
        stage('Cleanup Artifacts') {
            steps {
                sh 'docker rmi ${DOCKER_USERNAME}/${IMAGE_NAME}:${IMAGE_TAG}'
                sh 'docker rmi ${DOCKER_USERNAME}/${IMAGE_NAME}:latest'
            }
        }
    }
}