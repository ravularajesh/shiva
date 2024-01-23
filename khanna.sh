pipeline {
    agent any

    environment {
        AWS_ACCESS_KEY_ID     = 'AKIA6ODU7XTHQG43Y2VS'
        AWS_SECRET_ACCESS_KEY = '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'
        AWS_DEFAULT_REGION    = 'us-east-1'
        S3_BUCKET = 'shiva3'
        S3_FOLDER_BRANCHES = 'latest/'
        S3_FOLDER_TAGS = 'Develop/'
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

        stage('Push to S3') {
            steps {
                script {
                    def isBranch = env.BRANCH_NAME.startsWith('origin/')

                    if (isBranch) {
                        // Push branch to S3 folder
                        s3Upload(bucket: S3_BUCKET, workingDir: './', sourceFiles: '**', destination: "${S3_FOLDER_BRANCHES}/${env.BRANCH_NAME}")
                    } else {
                        // Push tag to S3 folder
                        s3Upload(bucket: S3_BUCKET, workingDir: './', sourceFiles: '**', destination: "${S3_FOLDER_TAGS}/${env.TAG_NAME}")
                    }
                }
            }
        }
    }
}

