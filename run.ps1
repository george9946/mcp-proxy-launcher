param(
    [int]$ProxyPort = 8001
)

$ErrorActionPreference = 'Stop'

$scriptDir = $PSScriptRoot
$localBin = Join-Path $env:USERPROFILE '.local\bin'
$env:Path = "$localBin;$env:Path"

$portListening = netstat -ano | Select-String -Pattern ":$ProxyPort\s+.*LISTENING"
if ($portListening) {
    Write-Host "MCP proxy is already running on port $ProxyPort. Skipping launch."
    return
}

$llamaServer = Get-Process -Name 'llama-server' -ErrorAction SilentlyContinue
if ($llamaServer) {
    Write-Host 'Llama server is already running. Skipping launch.'
}
else {
    Write-Host 'Starting llama server...'
    Start-Process -FilePath 'cmd.exe' -ArgumentList @(
        '/c',
        'run-llama-sycl.bat server -d "%USERPROFILE%\models" -m "%USERPROFILE%\models\google-gemma-4-E4B_q4_0-it.gguf" -mm "%USERPROFILE%\models\google-gemma-4-E4B-it-mmproj.gguf" -ngl 99 --no-mmap --n-cpu-moe 41 --webui-mcp-proxy --tools all'
    )
    Start-Sleep -Seconds 2
}

$condaBase = (& conda info --base).Trim()
$condaHook = Join-Path $condaBase 'shell\condabin\conda-hook.ps1'
. $condaHook
conda activate ai

$env:PYTHONPATH = (Join-Path $scriptDir 'src') + ';' + $env:PYTHONPATH
python -m pip install --quiet mcp-server-time mcp-server-fetch duckduckgo_mcp_server

$env:GITHUB_PERSONAL_ACCESS_TOKEN = 'your-github-token-here'

python -m mcp_proxy --named-server-config (Join-Path $scriptDir 'config.json') --allow-origin '*' --port $ProxyPort --stateless