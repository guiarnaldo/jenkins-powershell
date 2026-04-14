# Documentação da Pipeline Jenkins

## Pré-requisitos

### Plugins Jenkins
Instale os seguintes plugins no Jenkins:
- [ws-cleanup](https://plugins.jenkins.io/ws-cleanup/) - Limpeza de workspace
- [powershell](https://plugins.jenkins.io/powershell/) - Execução de scripts PowerShell

### Dependências do Windows
O NuGet e o MSBuild devem estar disponíveis no PATH do sistema. Ambos são instalados juntamente com o runtime do .NET.

## Configuração Inicial

### 1. Biblioteca Compartilhada
Adicione o repositório Git às configurações do Jenkins em:
**Manage Jenkins > Configure System > Global Trusted Pipeline Libraries**

### 2. Variável de Ambiente
Clone o repositório em um diretório de sua preferência e configure a variável de ambiente no Jenkins:
- Acesse: **Manage Jenkins > Configure System > Global properties**
- Adicione a variável: `jenkinsScriptsPath`
- Valor: Caminho completo do diretório onde os scripts foram clonados

### 3. Configuração das Variáveis
Renomeie o arquivo `.env.example` localizado na pasta `scripts` para `.env` e ajuste os valores conforme necessário.

## Exemplos de Uso

### Pipeline para Projeto Web

```groovy
#!groovy

@Library("web-api-project-pipeline-gitflow") _
webApiProjectPipelineGitflow {
    caminhoSolucao = "Cebi.Ssb.Principal.sln"
    caminhoProjetoWeb = "Cebi.Ssb.Principal.Web/Cebi.Ssb.Principal.Web.csproj"
    caminhoProjetoApi = "Cebi.Ssb.Principal.Api/Cebi.Ssb.Principal.Api.csproj"
    aplicacaoIIS = "ssb_principal"
}
```

### Pipeline para Biblioteca de Classes

```groovy
#!groovy

@Library("class-lib-project-pipeline") _
classLibProjectPipeline {
    caminhoSolucao = "Cebi.Ssb.BibliotecaRelatorios.sln"
    caminhoProjeto = "Cebi.Ssb.BibliotecaRelatorios/Cebi.Ssb.BibliotecaRelatorios.csproj"
    aplicacao = "BibliotecaRelatorios"
}
```