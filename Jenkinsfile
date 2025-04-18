pipeline {
    agent any

    environment {
        DOCKERHUB_USER = 'jasmine08'
        IMAGE_NAME = 'react-app'
    }

    stages {
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
				sshagent(['ssh-key']) {
					sh """
						ssh -o StrictHostKeyChecking=no ubuntu@15.207.206.25 '
							if [ ! -d "React-App-Project" ]; then
							git clone https://github.com/Jasmine-tech17/React-App-Project.git
							fi
							cd React-App-Project
							git fetch origin ${env.BRANCH_NAME}
							git reset --hard origin/${env.BRANCH_NAME}
							chmod +x docker-cleanup.sh
							./docker-cleanup.sh
							chmod +x deploy.sh
							./deploy.sh
						'
				"""
				}
			}
		}
    }

    triggers {
        githubPush()
    }
}

