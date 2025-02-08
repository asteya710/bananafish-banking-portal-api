pipeline {
  agent any
  /* environment {
    JAVA_HOME = '/usr/lib/jvm/java-17-openjdk' // Verify this path exists
  }

      stage('Check Java') {
        steps {
          sh 'echo "JAVA_HOME is set to: $JAVA_HOME"'
          sh 'java -version 2>&1' // Print Java version
        }
      } */
      stages {
      stage('List JDKs') {
            steps {
              script {
                // Check JDKs in standard paths (Linux/Unix)
                sh '''
                  echo "Checking installed JDKs..."
                  echo "--------------------------------------"

                  # Check common JDK directories
                  echo "JDKs in /usr/lib/jvm:"
                  ls -d /usr/lib/jvm/* | grep -E 'java|jdk'
                  echo "--------------------------------------"

                  # Check alternatives (if available)
                  if command -v update-alternatives &> /dev/null; then
                    echo "Java alternatives:"
                    update-alternatives --list java
                  fi
                  echo "--------------------------------------"

                  # Check JAVA_HOME for all JDKs
                  for jdk in $(ls -d /usr/lib/jvm/* | grep -E 'java|jdk'); do
                    echo "Version for $jdk:"
                    $jdk/bin/java -version 2>&1 || true
                    echo "--------------------------------------"
                  done
                '''
              }
            }
          }
    // Stage 1: Clone code and build the app
    stage('Build App') {
      steps {
        // Clone the repository FIRST
        git branch: 'develop', url: 'https://github.com/asteya710/bananafish-banking-portal-api.git'

        // Create ImageStream (if missing)
        script {
          openshift.withCluster() {
            openshift.withProject() {
              // Only create ImageStream if it doesn't exist
              if (!openshift.selector("is", "openjdk-17-ubi8").exists()) {
                openshift.create('''
                  apiVersion: image.openshift.io/v1
                  kind: ImageStream
                  metadata:
                    name: openjdk-17-ubi8
                  spec:
                    tags:
                    - name: "1.17-3"
                      from:
                        kind: DockerImage
                        name: registry.access.redhat.com/ubi8/openjdk-17:1.17-3
                ''')
              }
            }
          }
        }

        // Build the app with Maven
        sh 'chmod +x mvnw'
        sh "./mvnw clean install -Dmaven.compiler.release=17"

        // Read version from pom.xml
        script {
          def pom = readMavenPom file: 'pom.xml'
          version = pom.version
        }
      }
    }

    // Stage 2: Create BuildConfig if missing
    stage('Create Image Builder') {
      when {
        expression {
          openshift.withCluster() {
            openshift.withProject() {
              return !openshift.selector("bc", "banking-portal-api-new").exists()
            }
          }
        }
      }
      steps {
        script {
          openshift.withCluster() {
            openshift.withProject() {
              openshift.newBuild(
                "--name=banking-portal-api-new", // Consistent name
                "--image-stream=openjdk-17-ubi8:1.17-3",
                "--binary=true"
              )
            }
          }
        }
      }
    }

    // Stage 3: Build the image
    stage('Build Image') {
      steps {
        sh "rm -rf ocp && mkdir -p ocp/deployments"
        sh "pwd && ls -la target"
        // Use dynamic JAR name from pom.xml version
        sh "cp target/bananafish-banking-portal-api-${version}.jar ocp/deployments"

        script {
          openshift.withCluster() {
            openshift.withProject() {
              openshift.selector("bc", "banking-portal-api-new").startBuild(
                "--from-dir=./ocp",
                "--follow",
                "--wait=true"
              )
            }
          }
        }
      }
    }

    // Stage 4: Deploy the app
    stage('Deploy') {
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
              // Reference the ImageStreamTag explicitly
              def app = openshift.newApp("banking-portal-api-new:latest", "--as-deployment-config")
              app.narrow("svc").expose()
            }
          }
        }
      }
    }
  }
}