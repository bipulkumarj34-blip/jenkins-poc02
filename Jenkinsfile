pipeline {
    agent any

    parameters {
        choice(name: 'BRANCH', choices: ['main', 'develop'], description: 'Deploying branch')
    }

    environment {
        // This adds the Rancher Desktop bin folder to the system PATH for this build
        PATH = "/Users/bjha/.rd/bin:/usr/local/bin:/usr/bin:/bin:/usr/sbin:/sbin:${env.PATH}"
        MY_NAME = "bjha"
        IMAGE_NAME = "nginx-poc"
    }

    stages {
        stage('Preparation') {
            steps {
                // Verify docker is accessible now
                sh "docker --version"
                echo "Preparing build for ${params.BRANCH}..."
                sh "sed -i '' 's/##BUILD_NUMBER##/${env.BUILD_NUMBER}/g' index.html"
            }
        }

        stage('Quality Check (Parallel)') {
            parallel {
                stage('Validate Files') {
                    steps {
                        sh "ls -l index.html Dockerfile"
                    }
                }
                stage('Security Scan') {
                    steps {
                        echo "Simulating image vulnerability scan..."
                        sh "sleep 2" 
                    }
                }
            }
        }

        stage('Build & Tag') {
            steps {
                echo "Building image: ${env.MY_NAME}/${env.IMAGE_NAME}:${env.BUILD_NUMBER}"
                sh "docker build -t ${env.MY_NAME}/${env.IMAGE_NAME}:${env.BUILD_NUMBER} ."
                sh "docker tag ${env.MY_NAME}/${env.IMAGE_NAME}:${env.BUILD_NUMBER} ${env.MY_NAME}/${env.IMAGE_NAME}:latest"
            }
        }
    }

    post {
        success {
            echo "Successfully built locally in Rancher Desktop."
            echo "To view: docker run -d -p 8085:80 ${env.MY_NAME}/${env.IMAGE_NAME}:latest"
        }
    }
}