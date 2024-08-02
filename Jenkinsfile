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
        stage('Terraform Init and Import') {
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
                                    # Your existing import commands here
                                """
                            }
                        }
                    }
                }
            }
        }
        stage('Terraform Apply') {
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
                            terraform apply -auto-approve -var="alert_email=ynandini0625@gmail.com"
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
                        def snsTopicArn = sh(script: 'terraform output -raw sns_topic_arn || echo ""', returnStdout: true).trim()
                        if (snsTopicArn) {
                            sh """
                                export AWS_DEFAULT_REGION=us-east-2
                                export SNS_TOPIC_ARN=${snsTopicArn}
                                bash ${WORKSPACE}/detect_drift.sh ${config}
                            """
                        } else {
                            echo "Warning: No SNS Topic ARN found for ${config}. Skipping drift detection."
                        }
                    }
                }
            }
        }
    }
}
    }
}