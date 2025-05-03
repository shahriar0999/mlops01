pipeline {
    agent any
    environment {
        USERNAME = 'crownai'
        IMAGE_TAG = "${USERNAME}-${env.BUILD_NUMBER}"
    }

    stages {
        stage('Checkut Code') {
            steps {
                git url: "https://github.com/shahriar0999/mlops01.git", branch: "main"
                echo "Successfully cloning the project repo"
            }

        }


        stage("Test Code") {
            steps {
                echo "Testing Python Code..."
                sh ". venv/bin/activate && pytest tests/"
            }
        }

        stage('Login to docker hub') {
            steps {
                withCredentials([usernamePassword(credentialsId: 'docker_credential', usernameVariable: 'DOCKERHUB_USERNAME', passwordVariable: 'DOCKERHUB_PASSWORD')]) {
                    sh "echo ${DOCKERHUB_PASSWORD} | docker login -u ${DOCKERHUB_USERNAME} --password-stdin"} 
                    echo 'Login successfully'
            }
        }

        stage("Build Docker Images") {
            steps {
                script{
                    // Build both FastAPI and Streamlit app images
                    sh """
                        docker-compose build
                        docker tag prediction-application:latest $USERNAME/prediction-application:$IMAGE_TAG
                    """
                }
            }
        }

        stage("Push Docker Images") {
            steps {
                sh "docker push $USERNAME/prediction-application:$IMAGE_TAG"
            }
        }

        stage('Pull Docker Images') {
            steps {
                sh "docker pull $USERNAME/prediction-application:$IMAGE_TAG"
                
            }
        }

        stage("Run Docker Containers") {
            steps {
                sh 'docker-compose down'
                sh "docker-compose up -d"
            }
        }

    }
}