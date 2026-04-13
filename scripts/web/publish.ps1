$aplicacao = "$env:APLICACAO_IIS"
$branch = "$env:BRANCH_NAME"

# Robocopy:
# /E = Copia subpastas (incluindo vazias)
# /Z = Volta da onde parou se deu erro
# /R:3 = Tenta até 3 vezes
# /W:5 = 5 segundos entre cada tentativa

if ($branch -eq "master" -or $branch -Match "hotfix/"){
	robocopy "$env:WORKSPACE/build" "\\192.168.5.13/cebi/$aplicacao" /E /Z /R:3 /W:5
}

if ($branch -eq "develop"){
	robocopy "$env:WORKSPACE/build" "\\192.168.5.13/Dev01/$aplicacao" /E /Z /R:3 /W:5
}

if ($branch -Match "release/"){
	robocopy "$env:WORKSPACE/build" "\\192.168.5.13/Release/$aplicacao" /E /Z /R:3 /W:5
}

# O Robocopy não dá saída com o código 0, mesmo quando é sucesso
# O Jenkins verifica se o código de saída é diferente de 0 para lançar os erros
# Então faço a correção do código aqui
# https://ss64.com/nt/robocopy-exit.html

if ($exitCode -ge 8) {
    Write-Error "Robocopy falhou com código: $exitCode"
    exit 1
}
else {
    exit 0
}