$solution = "$env:WORKSPACE/$env:CAMINHO_SOLUCAO"
$caminho_build = "$env:WORKSPACE/build"
$caminho_web = "$env:WORKSPACE/$env:CAMINHO_WEB"
$caminho_api = "$env:WORKSPACE/$env:CAMINHO_API"
$caminho_projeto = "$env:WORKSPACE/$env:CAMINHO_PROJETO"
$caminho_segunda_via = "$env:WORKSPACE/$env:CAMINHO_SEGUNDA_VIA"

nuget restore $solution

if ($null -ne $caminho_web) {
	msbuild $caminho_web /p:DeployOnBuild=true /p:PublishProfile=Local /p:Platform=AnyCPU /p:Configuration=Release /p:PublishUrl=$caminho_build
}

if ($null -ne $caminho_projeto) {
	msbuild $caminho_projeto /p:DeployOnBuild=true /p:PublishProfile=Local /p:Platform=AnyCPU /p:Configuration=Release /p:PublishUrl=$caminho_build
}

if ($null -ne $caminho_api) {
	msbuild $caminho_api /p:DeployOnBuild=true /p:PublishProfile=Local /p:Platform=AnyCPU /p:Configuration=Release /p:PublishUrl=$caminho_build/Api
}

# Exclusivo da agência do STM
if ($null -ne $caminho_segunda_via) {
	msbuild $caminho_api /p:DeployOnBuild=true /p:PublishProfile=Local /p:Platform=AnyCPU /p:Configuration=Release /p:PublishUrl=$caminho_build/SegundaVia
}	

if ($LASTEXITCODE -ne 0) {
	throw "A Build falhou"
}