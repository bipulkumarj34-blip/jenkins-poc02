pipeline {
    agent any

    parameters {
        // This parameter allows you to select which branch to deploy from
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
                // Verify docker is accessible and prepare the build context
                sh "docker --version"
                echo "Preparing build for ${params.BRANCH}..."
                sh "sed -i '' 's/##BUILD_NUMBER##/${env.BUILD_NUMBER}/g' index.html"
            }
        }

        stage('Quality Check (Parallel)') {
            // Run file validation and security scan in parallel to speed up the process
            parallel {
                stage('Validate Files') {
                    steps {
                        // Check if the necessary files are present and have the expected content
                        echo "Validating Dockerfile and index.html..."
                        sh "ls -l index.html Dockerfile"
                    }
                }
                stage('Security Scan') {
                    steps {
                        // Simulate a security scan of the Docker image (replace with actual scan command if available)
                        echo "Simulating image vulnerability scan..."
                        sh "sleep 2" 
                    }
                }
            }
        }

        stage('Build & Tag') {
            // Build the Docker image and tag it with both the build number and 'latest'
            steps {
                echo "Building image: ${env.MY_NAME}/${env.IMAGE_NAME}:${env.BUILD_NUMBER}"
                sh "docker build -t ${env.MY_NAME}/${env.IMAGE_NAME}:${env.BUILD_NUMBER} ."
                sh "docker tag ${env.MY_NAME}/${env.IMAGE_NAME}:${env.BUILD_NUMBER} ${env.MY_NAME}/${env.IMAGE_NAME}:latest"
            }
        }
    }

    post {
        success {
            // Provide instructions to the user on how to run the built image locally in Rancher Desktop
            echo "Successfully built locally in Rancher Desktop."
            echo "To view: docker run -d -p 8085:80 ${env.MY_NAME}/${env.IMAGE_NAME}:latest"
        }
    }
}