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
        stage("Java Build"){
            steps {
                script {
                echo "Building Maven project to generate .jar file..."
                   // Use OpenShift's Maven image to run the build
                   sh '''
                       oc run maven-build --image=maven:3.8.4-openjdk-11 --overrides='
                       {
                         "apiVersion": "v1",
                         "kind": "Pod",
                         "metadata": {
                           "name": "maven-build"
                         },
                         "spec": {
                           "containers": [{
                             "name": "maven",
                             "image": "maven:3.8.4-openjdk-11",
                             "command": ["mvn", "clean", "install", "-DskipTests"],
                             "workingDir": "/workspace",
                             "volumeMounts": [{
                               "mountPath": "/workspace",
                               "name": "workspace-volume"
                             }]
                           }],
                           "volumes": [{
                             "name": "workspace-volume",
                             "hostPath": {
                               "path": "/tmp/workspace"  // Use workspace directory from Jenkins
                             }
                           }]
                         }
                       }'
                       '''
                    }
                }
        }
        stage("OpenShift build") {
            steps {
                sh '''
                       # Trigger a build from source code in the current directory using OpenShift ImageStream
                       oc new-build --name=banking-portal-api --binary --strategy=docker -n priyanshubhargav710-dev
                       oc start-build banking-portal-api --from-dir=./ --follow -n priyanshubhargav710-dev
                   '''
            }
        }
//         stage("Docker Build") {
//             steps {
//                  sh '''
//                         # Define variables
//                         PROJECT_NAME="banking-portal-ui"
//                         IMAGE_NAME="banking-portal-ui"
//                         NAMESPACE="priyanshubhargav710-dev"
//                         DOCKER_REGISTRY="default-route-openshift-image-registry.apps.rm3.7wse.p1.openshiftapps.com"
//                         DOCKER_IMAGE="$DOCKER_REGISTRY/$NAMESPACE/$IMAGE_NAME:latest"
//
//                         echo "Building Docker Image..."
//                         docker build -t $DOCKER_IMAGE .
//
//                         echo "Logging into OpenShift Registry..."
//                         docker login -u $(oc whoami) -p $(oc whoami -t) $DOCKER_REGISTRY
//
//                         echo "Pushing Docker Image..."
//                         docker push $DOCKER_IMAGE
//
//                         echo "Updating Deployment..."
//                         oc set image deployment/$PROJECT_NAME $PROJECT_NAME=$DOCKER_IMAGE -n $NAMESPACE
//                     '''
//             }
//         }
    }
}