pipeline {
    agent any

   environment {
        AWS_ACCESS_KEY_ID     = 'AKIA6ODU7XTHQG43Y2VS'
        AWS_SECRET_ACCESS_KEY = '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'
        AWS_DEFAULT_REGION    = 'us-east-1'
        S3_BUCKET             = 'shiva3'
        S3_FOLDER_BRANCH      = 'latest/'
        S3_FOLDER_TAG         = 'Develop/'
    }

    stages {
        stage('Checkout') {
            steps {
                script {
                    // Checkout the specific branch or tag
                    checkout([$class: 'GitSCM',  userRemoteConfigs: [[url: 'https://github.com/ravularajesh3333/saraswathi.git']]])
                }
            }
        }

        stage('Deploy to S3') {
            steps {
                script {
                    if (env.BRANCH_NAME ==~ /.*\/tags\/.*/) {
                        def tagName = env.BRANCH_NAME.replaceAll('.*/tags/', '')
                        def deployFolder = "${S3_FOLDER_TAG}${tagName}"

                        sh "aws s3 sync . s3://${S3_BUCKET}/${deployFolder}/ --delete"
                    } else {
                        def branchName = env.BRANCH_NAME.replaceAll('.*/', '')
                        def deployFolder = "${S3_FOLDER_BRANCH}${branchName}"

                        sh "aws s3 sync . s3://${S3_BUCKET}/${deployFolder}/ --delete"
                    }
                }
            }
        }
    }
}

