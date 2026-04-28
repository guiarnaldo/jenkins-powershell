$caminho_build = "$env:WORKSPACE/build"
$aplicacao = "$env:APLICACAO"
$branch = "$env:BRANCH_NAME"
$tamanhoBuffer = 64MB

if ($branch -ne "master" -or $branch -ne "legacy"){
    return
}

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

# Upload para o FTP que tem os pacotes do Nuget

Get-ChildItem $caminho_build/*.nupkg -name | ForEach-Object {
    try {
        $request = [System.Net.FtpWebRequest]::Create("$env:FTP/$_")
        $request.Credentials = New-Object System.Net.NetworkCredential($env:USUARIO, $env:SENHA)
        $request.Method = [System.Net.WebRequestMethods+Ftp]::UploadFile
        $request.UseBinary = $true
        $request.KeepAlive = $false
        $request.EnableSsl = $false
        $request.Proxy = $null

        $request.ContentLength = (Get-Item "$caminho_build/$_").Length

        $fileStream = [System.IO.File]::OpenRead("$caminho_build/$_")
        $ftpStream = $request.GetRequestStream()
        $buffer = New-Object byte[] $tamanhoBuffer
        $atual = 0

        while (($atual = $fileStream.Read($buffer, 0, $buffer.Length)) -gt 0) {
            $ftpStream.Write($buffer, 0, $atual)
        }

        $response = $request.GetResponse()
        Write-Host "Upload concluído: $($response.StatusDescription)"
        $response.Close()
    }
    catch {
        throw "Falha no upload para o FTP: $_"
    }
    finally {
        if ($fileStream) {
            $fileStream.Close() 
        }
        if ($ftpStream) {
            $ftpStream.Close()
        }
    }
}