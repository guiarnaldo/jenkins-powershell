$solution = "$env:WORKSPACE/$env:CAMINHO_SOLUCAO"
$caminho_build = "$env:WORKSPACE/build"
$caminho_projeto = "$env:WORKSPACE/$env:CAMINHO_PROJETO"

nuget restore $solution

if ($null -ne $caminho_projeto) {
	msbuild $caminho_projeto /p:DeployOnBuild=true /p:PublishProfile=Local /p:Platform=AnyCPU /p:Configuration=Release /p:PublishUrl=$caminho_build
}

if ($LASTEXITCODE -ne 0) {
	throw "A Build falhou"
}