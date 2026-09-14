pipeline {
    agent any

    parameters {
        choice(name: 'ENVIRONMENT', choices: ['dev', 'prod'], description: 'Which environment to target')
        choice(name: 'ACTION', choices: ['plan', 'apply', 'destroy'], description: 'Terraform action to run')
    }

    environment {
 
       TF_IN_AUTOMATION = 'true'
        TF_INPUT          = 'false'
        // Populate these via Jenkins Credentials (Manage Jenkins > Credentials), never hardcode:
        // AZURE_SUBSCRIPTION_ID, AZURE_TENANT_ID, AZURE_CLIENT_ID, AZURE_CLIENT_SECRET
        ARM_SUBSCRIPTION_ID = credentials('azure-subscription-id')
        ARM_TENANT_ID       = credentials('azure-tenant-id')
        ARM_CLIENT_ID       = credentials('azure-client-id')
        ARM_CLIENT_SECRET   = credentials('azure-client-secret')
       TF_VAR_ssh_public_key = credentials('ssh-public-key') 
}

    stages {

        stage('Checkout') {
            steps {
                checkout scm
            }
        }

        stage('Terraform Init') {
            steps {
                dir("terraform/environments/${params.ENVIRONMENT}") {
                    sh 'terraform init -input=false'
                }
            }
        }

        stage('Terraform Format Check') {
            steps {
                dir("terraform/environments/${params.ENVIRONMENT}") {
                    sh 'terraform fmt -check -recursive ../../'
                }
            }
        }

        stage('Terraform Validate') {
            steps {
                dir("terraform/environments/${params.ENVIRONMENT}") {
                    sh 'terraform validate'
                }
            }
        }

        stage('IaC Security Scan (tfsec)') {
            steps {
                dir("terraform/environments/${params.ENVIRONMENT}") {
                    // Non-blocking for now - flips to a hard gate once the team has triaged the baseline findings
                    sh 'tfsec . --soft-fail || true'
                }
            }
        }

        stage('Terraform Plan') {
            steps {
                dir("terraform/environments/${params.ENVIRONMENT}") {
                    sh "terraform plan -input=false -out=tfplan-${params.ENVIRONMENT}"
                }
            }
        }

        stage('Manual Approval') {
            when {
                expression { params.ACTION == 'apply' || params.ACTION == 'destroy' }
            }
            steps {
                input message: "Apply this plan to ${params.ENVIRONMENT}?", ok: 'Proceed'
            }
        }

        stage('Terraform Apply') {
            when {
                expression { params.ACTION == 'apply' }
            }
            steps {
                dir("terraform/environments/${params.ENVIRONMENT}") {
                    sh "terraform apply -input=false -auto-approve tfplan-${params.ENVIRONMENT}"
                }
            }
        }

        stage('Terraform Destroy') {
            when {
                expression { params.ACTION == 'destroy' }
            }
            steps {
                dir("terraform/environments/${params.ENVIRONMENT}") {
                    sh 'terraform destroy -input=false -auto-approve'
                }
            }
        }
    }

    post {
        always {
            dir("terraform/environments/${params.ENVIRONMENT}") {
                archiveArtifacts artifacts: "tfplan-${params.ENVIRONMENT}", allowEmptyArchive: true
            }
        }
        success {
            echo "Pipeline succeeded for ${params.ENVIRONMENT} (${params.ACTION})"
        }
        failure {
            echo "Pipeline failed for ${params.ENVIRONMENT} (${params.ACTION}) - check console output above"
        }
    }
}
