$nome_zip = "$env:NOME_ZIP"
$data_atual = "$env:DATA_ATUAL"
$build = "$env:BUILD_NUMBER"

Compress-Archive -Path $env:WORKSPACE/build/* -DestinationPath $env:WORKSPACE/${nome_zip}_v${data_atual}_${build}.zip