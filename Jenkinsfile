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
        stage('Terraform Init') {
            steps {
                withCredentials([
                    string(credentialsId: 'aws-access-key-id', variable: 'AWS_ACCESS_KEY_ID'),
                    string(credentialsId: 'aws-secret-access-key', variable: 'AWS_SECRET_ACCESS_KEY')
                ]) {
                    sh """
                        export AWS_DEFAULT_REGION=us-east-2
                        terraform init
                    """
                }
            }
        }
        stage('Create CloudWatch Log Group and Streams') {
            steps {
                withCredentials([
                    string(credentialsId: 'aws-access-key-id', variable: 'AWS_ACCESS_KEY_ID'),
                    string(credentialsId: 'aws-secret-access-key', variable: 'AWS_SECRET_ACCESS_KEY')
                ]) {
                    script {
                        sh '''
                            export AWS_DEFAULT_REGION=us-east-2
                            aws logs create-log-group --log-group-name /terraform/drift-detector || true
                            for config in config1 config2 config3; do
                                aws logs create-log-stream --log-group-name /terraform/drift-detector --log-stream-name ${config}-drift-logs || true
                            done
                        '''
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
                                    bash ${WORKSPACE}/detect_drift.sh ${config} ynandini0625@gmail.com
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