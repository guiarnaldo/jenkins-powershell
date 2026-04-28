#!groovy

def call(body) {

    def config = [:]
    body.resolveStrategy = Closure.DELEGATE_FIRST
    body.delegate = config
    body()
    def dataAtual = new Date().format("yy.MM.dd", TimeZone.getTimeZone('UTC'))
    def nomeZip = config.aplicacaoIIS.split('[/\\\\]')[-1]
    
    pipeline {
        agent any
        
        environment {
            CAMINHO_SOLUCAO = "${config.caminhoSolucao}"
            CAMINHO_PROJETO = "${config.caminhoProjeto}"
            CAMINHO_WEB = "${config.caminhoProjetoWeb}"
            CAMINHO_API = "${config.caminhoProjetoApi}"
            CAMINHO_SEGUNDA_VIA = "${config.caminhoSegundaVia}"
            APLICACAO_IIS = "${config.aplicacaoIIS}"
            DATA_ATUAL = "${dataAtual}"
            NOME_ZIP = "${nomeZip}"
            JENKINS_SCRIPTS_PATH = "${jenkinsScriptsPath}"
        }        

        stages {
            stage('Build') {
                steps {
                    powershell "${jenkinsScriptsPath}/web/build.ps1"
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
                    powershell "${jenkinsScriptsPath}/web/publish.ps1"
                }
            }
        }

        post {
            always {
                // Limpa os arquivos
                cleanWs()
            }
        }
    }
}