pipeline {
    agent any

    stages {
        stage('Hello') {
            steps {
                echo 'Hello World'
            }
        }
        stage("Checkout") {
            steps {
                checkout scm
            }
        }
        stage("Docker Build") {
            steps {
                 sh '''
                        # Define variables
                        PROJECT_NAME="banking-portal-ui"
                        IMAGE_NAME="banking-portal-ui"
                        NAMESPACE="priyanshubhargav710-dev"
                        DOCKER_REGISTRY="default-route-openshift-image-registry.apps.rm3.7wse.p1.openshiftapps.com"
                        DOCKER_IMAGE="$DOCKER_REGISTRY/$NAMESPACE/$IMAGE_NAME:latest"

                        echo "Building Docker Image..."
                        docker build -t $DOCKER_IMAGE .

                        echo "Logging into OpenShift Registry..."
                        docker login -u $(oc whoami) -p $(oc whoami -t) $DOCKER_REGISTRY

                        echo "Pushing Docker Image..."
                        docker push $DOCKER_IMAGE

                        echo "Updating Deployment..."
                        oc set image deployment/$PROJECT_NAME $PROJECT_NAME=$DOCKER_IMAGE -n $NAMESPACE
                    '''
            }
        }
    }
}