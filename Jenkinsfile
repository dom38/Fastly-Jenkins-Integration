import groovy.json.JsonSlurper

def s3_url = ''
def service_id = ''

pipeline {

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

                    sh "terraform init"
                    sh """terraform apply -lock=false -auto-approve \
                    -var-file=${variables}"""

                    script{

                        s3_url = sh returnStdout: true, script: 'terraform output bucket_endpoint'

                    }

                    echo "${s3_url}"

                }

            }
            
        }          

        stage ('Setup Service with Fastly') {

            steps {

                withCredentials([string(credentialsId: 'b77f3a2a-401e-4fc5-a7a4-125d0596505d', variable: 'key')]) {

                    script {

                        def result = sh returnStdout: true, script: """curl -X POST \
                                https://api.fastly.com/service \
                                -H 'Accept: application/json' \
                                -H 'Content-Type: application/x-www-form-urlencoded' \
                                -H 'Fastly-Key: ${key}' \
                                -H 'cache-control: no-cache' \
                                -d 'name=${s3_url}'"""

                        def json = new JsonSlurper().parseText(result)
                        service_id = json.id

                    }

                }
                
            }

        }

        stage ('Add Backend to Fastly Version') {

            steps {

                withCredentials([string(credentialsId: 'b77f3a2a-401e-4fc5-a7a4-125d0596505d', variable: 'key')]) {

                    script {

                        sh """curl -X POST \
                        https://api.fastly.com/service/${service_id}/version/1/backend \
                        -H 'Accept: application/json' \
                        -H 'Content-Type: application/x-www-form-urlencoded' \
                        -H 'Fastly-Key: ${key}' \
                        -H 'cache-control: no-cache' \
                        -d 'name=tterraform-service&address=${s3_url}&port=443&undefined='"""

                    }

                }

            }

            
        }

        stage ('Add domain') {

            steps {

                withCredentials([string(credentialsId: 'b77f3a2a-401e-4fc5-a7a4-125d0596505d', variable: 'key')]) {

                    script {

                        sh """curl -X POST \
                        https://api.fastly.com/service/${service_id}/version/1/domain \
                        -H 'Accept: application/json' \
                        -H 'Content-Type: application/x-www-form-urlencoded' \
                        -H 'Fastly-Key: ${key}' \
                        -H 'cache-control: no-cache' \
                        -d 'name=${s3_url}&undefined='"""

                    }

                }

            }
            
        }

        stage ('Activate Version') {

            steps {

                withCredentials([string(credentialsId: 'b77f3a2a-401e-4fc5-a7a4-125d0596505d', variable: 'key')]) {

                    script {

                        sh """curl -X PUT \
                        https://api.fastly.com/service/${service_id}/version/1/activate \
                        -H 'Accept: application/json' \
                        -H 'Fastly-Key: ${key}' \
                        -H 'cache-control: no-cache'"""

                    }

                }

            }
            
        }

        // stage ('Test files are available on CDN') {

            
        // }

        stage ('Clean Resources') {

            steps {

                withCredentials([file(credentialsId: '20423fae-782e-4cd1-be76-8bafe29e997d', variable: 'variables')])  {

                    sh """terraform destroy -lock=false -auto-approve \
                    -var-file=${variables}"""

                }

                withCredentials([string(credentialsId: 'b77f3a2a-401e-4fc5-a7a4-125d0596505d', variable: 'key')]) {

                    script {

                        sh """curl -X DELETE \
                        https://api.fastly.com/service/${service_id}\
                        -H 'Accept: application/json' \
                        -H 'Fastly-Key: ${key}' \
                        -H 'cache-control: no-cache' """

                    }

                }

            }

        }

    }

}