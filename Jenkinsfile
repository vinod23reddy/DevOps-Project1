pipeline {
    agent {
        label 'Jenkins-Agent'
    }
    tools {
        maven 'Maven3'
        jdk 'Java21'
    }
    environment {
    DOCKER_USERNAME = 'vinod23reddy'
    IMAGE_NAME      = 'DevOps-Project1'
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
                git url: 'https://github.com/vinod23reddy/DevOps-Project1.git', branch: 'main', credentialsId: 'github'
            }
        }
        stage('Build') {
            steps {
                sh 'mvn clean package'
            }
        }
        stage('Test') {
            steps {
                sh 'mvn test'
            }
        }
        stage('SonarQube Analysis') {
            steps {
                withSonarQubeEnv('sonarqube-server') { 
                    sh 'mvn sonar:sonar'
                }
            }
        }
<<<<<<< HEAD
        stage('Docker Build') {
            steps {
                sh 'docker build -t ${DOCKER_USERNAME}/${IMAGE_NAME}:${IMAGE_TAG} .'
            }
        }
        stage('Docker Push') {
            steps {
                sh 'echo $DOCKER_CREDS_PSW | docker login -u $DOCKER_CREDS_USR --password-stdin'
                sh 'docker push ${DOCKER_USERNAME}/${IMAGE_NAME}:${IMAGE_TAG}'
=======
        stage('Quality Gate') {
            steps {
                waitForQualityGate abortPipeline: true
>>>>>>> 39f66653590fd7277e88e2ad2752708538d0240e
            }
        }
    }
}
