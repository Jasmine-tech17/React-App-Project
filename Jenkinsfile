pipeline {
    agent any

    environment {
        DOCKERHUB_USER = 'jasmine08'   
        IMAGE_NAME = 'react-app'
    }

    stages {
        stage('Clone Repository') {
            steps {
                git branch: "${env.BRANCH_NAME}", url: 'https://github.com/Jasmine-tech17/React-App-Project.git'
            }
        }

        stage('Build Docker Image') {
            steps {
                sh 'docker build -t $IMAGE_NAME .'
            }
        }

        stage('Tag & Push Image') {
            steps {
                withCredentials([usernamePassword(credentialsId: 'docker-creds', usernameVariable: 'USER', passwordVariable: 'PASS')]) {
                    script {
                        docker.withRegistry('https://index.docker.io/v1/', 'docker-creds') {
                            def tag = (env.BRANCH_NAME == 'master') ? 'prod' : 'dev'
                            sh """
                                docker tag $IMAGE_NAME $DOCKERHUB_USER/$tag:latest
                                docker push $DOCKERHUB_USER/$tag:latest
                            """
                        }
                    }
                }
            }
        }

        stage('Deploy to EC2') {
            when {
                anyOf {
                    branch 'dev'
                    branch 'master'
                }
            }
            steps {
                sshagent(['sh-key']) {
                    sh '''
                        scp -o StrictHostKeyChecking=no deploy.sh ubuntu@<15.207.206.25>:/home/ubuntu/
                        ssh ubuntu@<15.207.206.25> "chmod +x /home/ubuntu/deploy.sh && ./deploy.sh"
                    '''
                }
            }
        }
    }

    triggers {
        githubPush()
    }
}
