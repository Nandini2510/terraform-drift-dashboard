pipeline {
    agent any
    tools {
        terraform 'terraform'
    }
    stages {
        stage('Checkout') {
            steps {
                git branch: 'main', url: 'https://github.com/Nandini2510/terraform-drift-dashboard.git'
            }
        }
         stage('Terraform Init and Apply') {
            steps {
                withCredentials([
                    string(credentialsId: 'aws-access-key-id', variable: 'AWS_ACCESS_KEY_ID'),
                    string(credentialsId: 'aws-secret-access-key', variable: 'AWS_SECRET_ACCESS_KEY')
                ]) {
                    sh """
                        export AWS_DEFAULT_REGION=us-east-2
                        terraform init
                        terraform apply -auto-approve -var="alert_email=ynandini0625@gmail.com"
                    """
                }
            }
        }
        stage('Terraform Init and Apply - Configs') {
            steps {
                script {
                    def configs = ['config1', 'config2', 'config3']
                    for (config in configs) {
                        dir(config) {
                            withCredentials([
                                string(credentialsId: 'aws-access-key-id', variable: 'AWS_ACCESS_KEY_ID'),
                                string(credentialsId: 'aws-secret-access-key', variable: 'AWS_SECRET_ACCESS_KEY')
                            ]) {
                                sh """
                                    export AWS_DEFAULT_REGION=us-east-2
                                    terraform init
                                    terraform apply -auto-approve
                                """
                            }
                        }
                    }
                }
            }
        }
        stage('Detect Drift') {
            steps {
                script {
                    def configs = ['config1', 'config2', 'config3']
                    for (config in configs) {
                        dir(config) {
                            withCredentials([
                                string(credentialsId: 'aws-access-key-id', variable: 'AWS_ACCESS_KEY_ID'),
                                string(credentialsId: 'aws-secret-access-key', variable: 'AWS_SECRET_ACCESS_KEY')
                            ]) {
                                sh """
                                    export AWS_DEFAULT_REGION=us-east-2
                                    export RESOURCE_TYPE=${getResourceType(config)}
                                    bash ${WORKSPACE}/detect_drift.sh ${config}
                                """
                            }
                        }
                    }
                }
            }
        }
    }
}

def getResourceType(config) {
    switch(config) {
        case 'config1':
            return 'S3Bucket'
        case 'config2':
            return 'SNSTopic'
        case 'config3':
            return 'CloudWatchLogGroup'
        default:
            return 'Unknown'
    }
}