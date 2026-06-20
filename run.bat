

@echo off
setlocal enabledelayedexpansion

set Path=C:\Users\E0099460\.local\bin;!Path!
set "PROXY_PORT=8001"

REM Check if the MCP proxy is already running on the target port
netstat -ano | findstr /I /R /C:":%PROXY_PORT% .*LISTENING" >NUL
if "%ERRORLEVEL%"=="0" (
    echo MCP proxy is already running on port %PROXY_PORT%. Skipping launch.
    goto :EOF
)

REM Check if llama-server is already running
tasklist /FI "IMAGENAME eq llama-server.exe" 2>NUL | find /I /N "llama-server.exe">NUL
if "%ERRORLEVEL%"=="0" (
    echo Llama server is already running. Skipping launch.
) else (
    echo Starting llama server...
    start "" cmd /c "run-llama-sycl.bat server -d ^"C:\Users\E0099460\models^" -m ^"gemma-4-E2B-it-UD-IQ3_XXS.gguf^" -mm ^"unsloth-mmproj-F16^" -ngl 99 --no-mmap --n-cpu-moe 41 --webui-mcp-proxy"
    timeout /t 2 /nobreak
)


REM activate and setup MCP servers locally
call conda activate ai
python -m pip install --quiet mcp-server-time mcp-server-fetch duckduckgo_mcp_server

@REM npm install -g @modelcontextprotocol/server-github
set GITHUB_PERSONAL_ACCESS_TOKEN=your-github-token-here

python -m mcp_proxy --named-server-config config.json --allow-origin "*" --port %PROXY_PORT% --stateless