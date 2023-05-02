pipeline{
	agent any
	tools{
		maven 'M2_HOME'
		terraform 'T2_HOME'
	}
        environment {
           DOCKERHUB_CREDENTIALS = credentials('dockerhub')
        }   
	stages{
		stage('gitcheckout'){
			steps {
				git branch: 'main', url: 'https://github.com/snehalatha1/healthcare.git'
			}
		}
		stage('package'){
			steps{
			   sh 'mvn clean package'
			}
		}
		stage('publish reports using html'){
			steps{
				publishHTML([allowMissing: false, alwaysLinkToLastBuild: false, keepAll: false, reportDir: '/var/lib/jenkins/workspace/health/target/surefire-reports', reportFiles: 'index.html', reportName: 'HTML Report', reportTitles: '', useWrapperFileDirectly: true])
			}
		}
		stage('Docker Image Creation'){
                    steps {
                        sh 'docker build -t snehalatha15/healthcare:latest  .'
                    }
                 }
                 stage('login'){
                      steps {
                         sh 'echo $DOCKERHUB_CREDENTIALS_PSW | docker login -u $DOCKERHUB_CREDENTIALS_USR --password-stdin'
                      }
                 }
                 stage('push'){
                       steps{
                          sh 'docker push snehalatha15/healthcare:latest'
                       }  
                 }    
              stage ('Configure newserver with Terraform'){
                  steps {
                     sh 'chmod 700 mykey.pem'
                     sh 'terraform init'
                     sh 'terraform validate'
                     sh 'terraform apply --auto-approve'
                  }
              }
}
}
