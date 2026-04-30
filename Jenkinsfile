pipeline {
    agent {
        label 'Jenkins-Agent'
    }
    tools {
        maven 'Maven3'
        jdk 'Java21'
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
    }
}
