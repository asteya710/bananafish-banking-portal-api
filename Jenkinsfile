pipeline
    {
       agent any
       environment {
           JAVA_HOME = '/usr/lib/jvm/java-17-openjdk-amd64' // Path to JDK
           PATH = "${JAVA_HOME}/bin:${env.PATH}"
         }
        stages
        {
          stage('Build App')
          {
            steps
             {
             sh 'chmod +x /usr/lib/jvm/java-17-openjdk-amd64'
             sh 'java -version'
             sh 'chmod +x mvnw'
             sh "./mvnw clean install"
              git branch: 'develop', url: 'https://github.com/asteya710/bananafish-banking-portal-api.git'
              script {
                  def pom = readMavenPom file: 'pom.xml'
                  version = pom.version
              }
            }
          }
          stage('Create Image Builder') {
            when {
              expression {
                openshift.withCluster() {
                  openshift.withProject() {
                    return !openshift.selector("bc", "banking-portal-api-new").exists();
                  }
                }
              }
            }
            steps {
              script {
                openshift.withCluster() {
                  openshift.withProject() {
                    openshift.newBuild("--name=sample-app-jenkins-new", "--image-stream=openjdk-17-ubi8:1.17-3", "--binary=true")
                  }
                }
              }
            }
          }
          stage('Build Image') {
            steps {
              sh "rm -rf ocp && mkdir -p ocp/deployments"
              sh "pwd && ls -la target "
              sh "cp target/openshiftjenkins-0.0.1-SNAPSHOT.jar ocp/deployments"

              script {
                openshift.withCluster() {
                  openshift.withProject() {
                    openshift.selector("bc", "banking-portal-api-new").startBuild("--from-dir=./ocp","--follow", "--wait=true")
                  }
                }
              }
            }
          }
          stage('deploy') {
            when {
              expression {
                openshift.withCluster() {
                  openshift.withProject() {
                    return !openshift.selector('dc', 'banking-portal-api-new').exists()
                  }
                }
              }
            }
            steps {
              script {
                openshift.withCluster() {
                  openshift.withProject() {
                    def app = openshift.newApp("banking-portal-api-new", "--as-deployment-config")
                    app.narrow("svc").expose();
                  }
                }
              }
            }
          }
        }
    }