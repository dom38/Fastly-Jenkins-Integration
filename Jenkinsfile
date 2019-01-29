pipeline {

    environment {

        s3_url = ''

    }

    agent { label 'terraform' }

    
    stages {

        stage ('Checkout Repo') {

            steps {

                git credentialsId: '6d3a9d73-2730-4da5-9065-29cebcd13c1c', url: 'https://github.com/dom38/Fastly-Jenkins-Integration.git'

            }
            
        }

        stage ('Setup S3 with Terraform') {

            steps {

                withCredentials([file(credentialsId: '20423fae-782e-4cd1-be76-8bafe29e997d', variable: 'variables')])  {

                    sh """terraform apply -lock=false -auto-approve \
                    -var-file=${variables}"""

                    s3_url = (sh "terraform output bucket_endpoint")

                    //Debug for first run
                    echo "${s3_url}"

                    sh """terraform destroy -lock=false -auto-approve \
                    -var-file=${variables}"""

                }

            }
            
        }

        // stage ('Setup Service with Fastly') {


        // }

        // stage ('Add Domain to Fastly Service') {

            
        // }

        // stage ('Test files are available on CDN') {

            
        // }

        // stage ('Clean Resources') {

            
        // }
    }

}