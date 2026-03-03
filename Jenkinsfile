pipeline {

    agent { label 'dev' }

    tools {
        maven 'mymaven'
    }

    environment {
        SERVICES      = "order-service product-service user-service"

        SONAR_AUTH_TOKEN = credentials('sonar')
        DOCKERHUB_CREDS  = credentials('dockerhub')

        SCANNER_HOME = tool "mysonar"

        DOCKER_USER = "prav1619"
        REPO = "quickart"

        KUBE_CONFIG = credentials('kubeconfig-file')   // <-- ADD THIS IN JENKINS CREDENTIALS
        NAMESPACE = "quickart"
    }

    stages {

        /* 
           1. Checkout
      */
        stage("Checkout Code") {
            steps {
                git branch: 'main', url: 'https://github.com/Prav1619/Quickart-app.git'
            }
        }

        /* 
           2. Maven Build
       */
        stage("Maven Build (ALL services)") {
            steps {
                sh "mvn clean install -DskipTests"
            }
        }

        /* 
           3. SonarQube
       */
        stage("SonarQube Analysis") {
            steps {
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

        /* 
           4. Docker Build
        */
        stage("Docker Image Build") {
            steps {
                script {
                    SERVICES.split(" ").each { svc ->
                        def image = "${DOCKER_USER}/${REPO}-${svc}:${BUILD_NUMBER}"
                        sh "docker build -t ${image} ${svc}"
                    }
                }
            }
        }

        /* 
           5. Trivy Scan
        */
        stage("Trivy Scan") {
            steps {
                script {
                    SERVICES.split(" ").each { svc ->
                        def image = "${DOCKER_USER}/${REPO}-${svc}:${BUILD_NUMBER}"
                        sh "trivy image --exit-code 0 --format table ${image}"
                    }
                }
            }
        }

        /* 
           6. Docker Push
        */
        stage("DockerHub Push") {
            steps {
                script {
                    sh "echo '${DOCKERHUB_CREDS_PSW}' | docker login -u '${DOCKERHUB_CREDS_USR}' --password-stdin"

                    SERVICES.split(" ").each { svc ->
                        def image = "${DOCKER_USER}/${REPO}-${svc}:${BUILD_NUMBER}"
                        sh "docker push ${image}"
                    }
                }
            }
        }

        /* 
           7. Kubernetes Deploy
        */
        stage("Deploy to Kubernetes") {
            steps {
                script {

                    writeFile file: "kubeconfig", text: KUBE_CONFIG
                    sh "export KUBECONFIG=kubeconfig"

                    SERVICES.split(" ").each { svc ->

                        def image = "${DOCKER_USER}/${REPO}-${svc}:${BUILD_NUMBER}"

                        echo "Deploying ${svc} with image: ${image}"

                        sh """
                        kubectl set image deployment/${svc} ${svc}=${image} -n ${NAMESPACE}
                        kubectl rollout status deployment/${svc} -n ${NAMESPACE} --timeout=60s
                        """
                    }
                }
            }
        }

    }

    /* 
       Auto Rollback + Cleanup
    */
    post {

        failure {
            script {

                writeFile file: "kubeconfig", text: KUBE_CONFIG
                sh "export KUBECONFIG=kubeconfig"

                echo "Deployment failed! Rolling back all services..."

                SERVICES.split(" ").each { svc ->
                    sh """
                    kubectl rollout undo deployment/${svc} -n ${NAMESPACE}
                    """
                }
            }
        }

        always {
            cleanWs()
        }
    }
}
