$solution = "$env:WORKSPACE/$env:CAMINHO_SOLUCAO"
$caminho_build = "$env:WORKSPACE/build"
$caminho_web = "$env:WORKSPACE/$env:CAMINHO_WEB"

if ($null -ne $solution) {
	msbuild $solution -t:restore -t:pack /p:DeployOnBuild=true /p:PublishProfile=Local /p:Platform=AnyCPU /p:Configuration=Release /p:PublishUrl=$caminho_build
}

if ($LASTEXITCODE -ne 0) {
	throw "A Build falhou"
}