Pipeline {

    agent {label: '##Insert'}

    stages {

        stage ('Setup S3') {

            withCredentials([file(credentialsId: '20423fae-782e-4cd1-be76-8bafe29e997d', variable: 'variables')])  {

                sh """terraform apply \
                -var-file=${variables}"""

            }
            
        }

        stage ('Setup Service') {


        }

        stage ('Add Domain') {

            
        }

        stage ('Test') {

            
        }
    }

}