#!groovy

def call(body) {

    def config = [:]
    body.resolveStrategy = Closure.DELEGATE_FIRST
    body.delegate = config
    body()

    pipeline {
        agent any
        
        environment {
            CAMINHO_SOLUCAO = "${config.caminhoSolucao}"
            CAMINHO_PROJETO = "${config.caminhoProjeto}"
            APLICACAO = "${config.aplicacao}"
            NOME_ZIP = "${nomeZip}"
            JENKINS_SCRIPTS_PATH = "${jenkinsScriptsPath}"
        }        

        stages {
            stage('Build') {
                steps {
                    powershell "${jenkinsScriptsPath}/package/build.ps1"
                }
            }

            stage ('Archive') {
                steps {
                    powershell "${jenkinsScriptsPath}/archive.ps1"
                    archiveArtifacts artifacts: "${env.NOME_ZIP}_v${env.DATA_ATUAL}_${env.BUILD_NUMBER}.zip"
                }
            }

            stage ('Publish') {
                steps {
                    powershell "${jenkinsScriptsPath}/package/publish.ps1"
                }
            }
        }
    }
}