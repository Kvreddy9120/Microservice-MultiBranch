pipeline {
    agent any

    stages {
        stage('Deploy to K8S') {
            steps {
                withKubeCredentials(kubectlCredentials: [[caCertificate: '', clusterName: ' EKS-1', contextName: '', credentialsId: 'K8s-Cred', namespace: 'webapps', serverUrl: 'https://A57CDCAB8E520834D41DE66081BFAEDB.gr7.us-east-1.eks.amazonaws.com']]) {
                    sh "kubectl apply -f deployment-service.yml"
                }
            }
        }
        stage('Verify Deployment') {
            steps {
                withKubeCredentials(kubectlCredentials: [[caCertificate: '', clusterName: ' EKS-1', contextName: '', credentialsId: 'K8s-Cred', namespace: 'webapps', serverUrl: 'https://A57CDCAB8E520834D41DE66081BFAEDB.gr7.us-east-1.eks.amazonaws.com']]) {
                    sh "kubectl get svc -n webapps"
                }
            }
        }
    }
}
