$solution = Join-Path $env:WORKSPACE $env:CAMINHO_SOLUCAO
$caminho_build = Join-Path $env:WORKSPACE "build"
$caminho_web = Join-Path $env:WORKSPACE $env:CAMINHO_WEB
$caminho_api = Join-Path $env:WORKSPACE $env:CAMINHO_API
$caminho_projeto = Join-Path $env:WORKSPACE $env:CAMINHO_PROJETO
$caminho_segunda_via = Join-Path $env:WORKSPACE $env:CAMINHO_SEGUNDA_VIA

nuget restore $solution

if ($null -ne $env:CAMINHO_PROJETO) {
	msbuild $caminho_projeto /p:DeployOnBuild=true /p:PublishProfile=Local /p:Platform=AnyCPU /p:Configuration=Release /p:PublishUrl=$caminho_build
}

if ($null -ne $env:CAMINHO_WEB) {
	msbuild $caminho_web /p:DeployOnBuild=true /p:PublishProfile=Local /p:Platform=AnyCPU /p:Configuration=Release /p:PublishUrl=$caminho_build
}

if ($null -ne $env:CAMINHO_API) {
	msbuild $caminho_api /p:DeployOnBuild=true /p:PublishProfile=Local /p:Platform=AnyCPU /p:Configuration=Release /p:PublishUrl=$caminho_build/Api
}

# Exclusivo da agência do STM
if ($null -ne $env:CAMINHO_SEGUNDA_VIA -or "null" -ne $env:CAMINHO_SEGUNDA_VIA) {
	msbuild $caminho_segunda_via /p:DeployOnBuild=true /p:PublishProfile=Local /p:Platform=AnyCPU /p:Configuration=Release /p:PublishUrl=$caminho_build/SegundaVia
}