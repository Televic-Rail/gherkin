#!groovy

import org.jenkinsci.plugins.pipeline.modeldefinition.Utils

DOCKER_TAG = '2.3.1'

void callDockerToTest(folder)
{
    echo "callDockerToTest with folder ${folder}"
    sh """
         docker run \
             -v ${WORKSPACE}:/home/jenkins \
             docker-tra.televic.com/jenkins/python:${DOCKER_TAG} python/bin/test_gherkin_package.sh -f=${folder}
    """
}

void callDockerToPublish(folder)
{
    echo "callDockerToPublish with folder ${folder}"
    sh """
            docker run \
                -v ${WORKSPACE}:/home/jenkins \
                -e USR=\"${USR}\" \
                -e PASSW=\"${PASSW}\" \
                docker-tra.televic.com/jenkins/python:${DOCKER_TAG} python/bin/publish_gherkin_package.sh -f=${folder}
        """
}


pipeline {
    // Define building node
    agent { label 'ubuntu1' }

     // Logs
    options {
        buildDiscarder(logRotator(numToKeepStr: '5', daysToKeepStr: '8'))
        timestamps ()
    }

    stages {
        stage('Pull Docker image') {
            steps {
                sh """
                    docker pull docker-tra.televic.com/jenkins/python:${DOCKER_TAG}
                """
            }
        }

        stage('Test package') {
            steps {
                script {
                    callDockerToTest("python/test")
                }
            }
        }

        stage('Publish package') {
            steps {
                script {
                    withCredentials([usernamePassword(credentialsId: 'build.server.rail', passwordVariable: 'PASSW', usernameVariable: 'USR')])
                    {
                        callDockerToPublish("python")
                    }
                }
            }
        }
    }
}
