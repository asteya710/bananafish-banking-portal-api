pipeline {
    agent {
        label "maven"
    }
    stages {
        stage('Setup') {
            steps {
                echo 'Testing Pipeline'
            }
        }
        stage("Checkout") {
            steps {
                checkout scm
            }
        }
        stage("Docker Build") {
            steps {
                script {
                    // Start the Docker build in OpenShift
                    sh 'oc start-build bananafish-banking-portal-api --from-dir=. --follow'
                }
            }
        }
    }
}

// library identifier: "pipeline-library@v1.6",
// retriever: modernSCM(
//   [
//     $class: "GitSCMSource",
//     remote: "https://github.com/redhat-cop/pipeline-library.git"
//   ]
// )
//
// // The name you want to give your Spring Boot application
// // Each resource related to your app will be given this name
// appName = "bananafish-banking-portal-api"
//
// pipeline {
//     // Use the 'maven' Jenkins agent image which is provided with OpenShift
//     agent {
//         label "maven"
//      }
//     stages {
//          stage('Setup') {
//             steps {
//                 echo 'Testing Pipeline'
//             }
//         }
//         stage("Checkout") {
//             steps {
//                 checkout scm
//             }
//         }
//         stage("Docker Build") {
//             steps {
//                 // This uploads your application's source code and performs a binary build in OpenShift
//                 // This is a step defined in the shared library (see the top for the URL)
//                 // (Or you could invoke this step using 'oc' commands!)
//                 binaryBuild(buildConfigName: bananafish-banking-portal-api, buildFromPath: ".")
//             }
//         }
//
//         // You could extend the pipeline by tagging the image,
//         // or deploying it to a production environment, etc......
//     }
// }
//
// // pipeline {
// //     agent {
// //         label 'maven'
// //     }
// //
// //     stages {
// //         stage('Hello') {
// //             steps {
// //                 echo 'Hello World'
// //             }
// //         }
// // //         stage("Checkout") {
// // //             steps {
// // //                 checkout scm
// // //             }
// // //         }
// //         stage('Build App') {
// //             steps {
// //               git branch: 'main', url: 'https://github.com/asteya710/bananafish-banking-portal-api.git'
// //                   script {
// //                       def pom = readMavenPom file: 'pom.xml'
// //                       version = pom.version
// //                   }
// //               sh "mvn install"
// //             }
// //         }
// // //         stage("OpenShift build") {
// // //             steps {
// // //                 sh '''
// // //                        # Trigger a build from source code in the current directory using OpenShift ImageStream
// // //                        oc new-build --name=banking-portal-api --binary --strategy=docker -n priyanshubhargav710-dev
// // //                        oc start-build banking-portal-api --from-dir=./ --follow -n priyanshubhargav710-dev
// // //                    '''
// // //             }
// // //         }
// //         stage('Create Image Builder') {
// //                 when {
// //                   expression {
// //                         openshift.withCluster() {
// //                               openshift.withProject() {
// //                                 return !openshift.selector("bc", "banking-portal-api").exists();
// //                               }
// //                         }
// //                   }
// //                 }
// //                 steps {
// //                   script {
// //                         openshift.withCluster() {
// //                               openshift.withProject() {
// //                                 openshift.newBuild("--name=banking-portal-api", "--image-stream=openjdk18-openshift:1.14-3", "--binary=true")
// //                               }
// //                         }
// //                   }
// //                 }
// //           }
// //
// // //         stage("Docker Build") {
// // //             steps {
// // //                  sh '''
// // //                         # Define variables
// // //                         PROJECT_NAME="banking-portal-ui"
// // //                         IMAGE_NAME="banking-portal-ui"
// // //                         NAMESPACE="priyanshubhargav710-dev"
// // //                         DOCKER_REGISTRY="default-route-openshift-image-registry.apps.rm3.7wse.p1.openshiftapps.com"
// // //                         DOCKER_IMAGE="$DOCKER_REGISTRY/$NAMESPACE/$IMAGE_NAME:latest"
// // //
// // //                         echo "Building Docker Image..."
// // //                         docker build -t $DOCKER_IMAGE .
// // //
// // //                         echo "Logging into OpenShift Registry..."
// // //                         docker login -u $(oc whoami) -p $(oc whoami -t) $DOCKER_REGISTRY
// // //
// // //                         echo "Pushing Docker Image..."
// // //                         docker push $DOCKER_IMAGE
// // //
// // //                         echo "Updating Deployment..."
// // //                         oc set image deployment/$PROJECT_NAME $PROJECT_NAME=$DOCKER_IMAGE -n $NAMESPACE
// // //                     '''
// // //             }
// // //         }
// //
// //         stage('Build Image') {
// //             steps {
// //                   sh "rm -rf ocp && mkdir -p ocp/deployments"
// //                   sh "pwd && ls -la target "
// //                   sh "cp target/openshiftjenkins-0.0.1-SNAPSHOT.jar ocp/deployments"
// //
// //                   script {
// //                         openshift.withCluster() {
// //                               openshift.withProject() {
// //                                 openshift.selector("bc", "sample-app-jenkins-new").startBuild("--from-dir=./ocp","--follow", "--wait=true")
// //                               }
// //                         }
// //                   }
// //             }
// //         }
// //
// //                   stage('deploy') {
// //                         when {
// //                               expression {
// //                                     openshift.withCluster() {
// //                                       openshift.withProject() {
// //                                         return !openshift.selector('dc', 'sample-app-jenkins-new').exists()
// //                                       }
// //                                     }
// //                               }
// //                         }
// //                     steps {
// //                       script {
// //                             openshift.withCluster() {
// //                               openshift.withProject() {
// //                                 def app = openshift.newApp("sample-app-jenkins-new", "--as-deployment-config")
// //                                 app.narrow("svc").expose();
// //                               }
// //                             }
// //                       }
// //                     }
// //                   }
// //
// //     }
// // }