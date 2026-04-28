$solution = Join-Path $env:WORKSPACE $env:CAMINHO_SOLUCAO
$caminho_build = Join-Path $env:WORKSPACE "build"
$caminho_projeto = Join-Path $env:WORKSPACE $env:CAMINHO_PROJETO

nuget restore $solution

# Verifica a versão do .NET através do .csproj, se houver a tag "TargetFrameworkVersion" é um projeto do .NET Framework
$versao = Select-String -Path $caminho_projeto -Pattern "TargetFrameworkVersion" -Quiet
if ($versao) {
	msbuild $caminho_projeto /t:Rebuild /p:DeployOnBuild=true /p:Configuration=Release
	nuget pack $caminho_projeto -Prop Configuration=Release -OutputDirectory $caminho_build
}
else {
	dotnet pack $caminho_projeto -c Release --output $caminho_build
}

if ($LASTEXITCODE -ne 0) {
	throw "A Build falhou"
}