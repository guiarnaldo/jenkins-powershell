#!groovy

def call(body) {

    def config = [:]
    body.resolveStrategy = Closure.DELEGATE_FIRST
    body.delegate = config
    body()
    def dataAtual = new Date().format("yy.MM.dd", TimeZone.getTimeZone('UTC'))

    pipeline {
        agent any
        
        environment {
            CAMINHO_SOLUCAO = "${config.caminhoSolucao}"
            CAMINHO_PROJETO = "${config.caminhoProjeto}"
            APLICACAO = "${config.aplicacao}"
            DATA_ATUAL = "${dataAtual}"
            NOME_ZIP = "${nomeZip}"
        }        

        stages {
            stage('Build') {
                steps {
                    powershell "${jenkinsScriptsPath}/package/build.ps1"
                }
            }
        }
    }
}