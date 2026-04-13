# Lê o arquivo .env e seta as variáveis de ambiente contidas nele

try {
    Get-Content $env:JENKINS_SCRIPTS_PATH/.env | ForEach-Object {
        $name, $value = $_.split('=')

        # Pula os comentários no .env
        if ([string]::IsNullOrWhiteSpace($name) -or $name.StartsWith('#')) {
            return
        }
        Set-Content env:\$name $value
    }
}
catch {
    throw "Falha ao definir as variáveis de ambiente, verifique o .env: $_"
}