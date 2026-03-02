pipeline {
    agent { label 'dev' }

    tools {
        maven 'mymaven'
    }

    environment {
        SERVICES = "order-service product-service user-service"

        SONAR_AUTH_TOKEN = credentials('sonar')
        DOCKERHUB_CREDS  = credentials('dockerhub')

        SCANNER_HOME = tool "mysonar"

        DOCKER_USER = "prav1619"
        REPO = "quickart"
    }

    stages {

        stage("Checkout Code") {
            steps {
                git branch: 'main', url: 'https://github.com/Prav1619/Quickart-app.git'
            }
        }

        stage("Maven Build (ALL services)") {
            steps {
                echo "Building entire multi-module project..."
                sh "mvn clean install -DskipTests"
            }
        }

        stage("SonarQube Analysis (ROOT POM)") {
            steps {
                script {
                    echo "Running SonarQube analysis at ROOT level"

                    withSonarQubeEnv("mysonar") {
                        sh """
                        mvn sonar:sonar \
                            -Dsonar.projectKey=quickart-app \
                            -Dsonar.host.url=$SONAR_HOST_URL \
                            -Dsonar.login=$SONAR_AUTH_TOKEN
                        """
                    }
                }
            }
        }

        stage("Docker Image Build") {
            steps {
                script {
                    SERVICES.split(" ").each { svc ->
                        
                        def image = "${DOCKER_USER}/${REPO}-${svc}:${BUILD_NUMBER}"
                        
                        echo "Building Docker image for: ${svc}"
                        
                        sh """
                        docker build -t ${image} ${svc}
                        """
                    }
                }
            }
        }

        stage("Trivy Scan") {
            steps {
                script {
                    SERVICES.split(" ").each { svc ->
                        
                        def image = "${DOCKER_USER}/${REPO}-${svc}:${BUILD_NUMBER}"

                        echo "Scanning image: ${image}"

                        sh """
                        trivy image --exit-code 0 --format table ${image}
                        """
                    }
                }
            }
        }

        stage("DockerHub Push") {
            steps {
                script {
                    sh "echo '${DOCKERHUB_CREDS_PSW}' | docker login -u '${DOCKERHUB_CREDS_USR}' --password-stdin"

                    SERVICES.split(" ").each { svc ->

                        def image = "${DOCKER_USER}/${REPO}-${svc}:${BUILD_NUMBER}"
                        
                        echo "Pushing image: ${image}"
                        sh "docker push ${image}"
                    }
                }
            }
        }
    }

    post {
        always {
            cleanWs()
        }
    }
}
