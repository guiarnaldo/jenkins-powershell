$solution = "$env:WORKSPACE/$env:CAMINHO_SOLUCAO"
$caminho_build = "$env:WORKSPACE/build"
$caminho_projeto = "$env:WORKSPACE/$env:CAMINHO_PROJETO"

nuget restore $solution
nuget pack $caminho_projeto -Prop Configuration=Release -OutputDirectory "$caminho_build/"

if ($LASTEXITCODE -ne 0) {
	throw "A Build falhou"
}