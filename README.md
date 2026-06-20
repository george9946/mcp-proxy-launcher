# mcp-proxy-launcher

Launcher and preset config for a local MCP proxy.

The original upstream documentation lives in [MCP-PROXY.md](MCP-PROXY.md).

## What this repo runs

Current local config is defined in [config.json](config.json).

It starts these named MCP servers behind the proxy:

- `time`
- `ddg-search`
- `fetch`
- `github`

## Endpoints created

Proxy base URL:

- `http://127.0.0.1:8001`

SSE endpoints:

- `http://127.0.0.1:8001/servers/time/sse`
- `http://127.0.0.1:8001/servers/ddg-search/sse`
- `http://127.0.0.1:8001/servers/fetch/sse`
- `http://127.0.0.1:8001/servers/github/sse`

Streamable HTTP endpoints:

- `http://127.0.0.1:8001/servers/time/mcp`
- `http://127.0.0.1:8001/servers/ddg-search/mcp`
- `http://127.0.0.1:8001/servers/fetch/mcp`
- `http://127.0.0.1:8001/servers/github/mcp`

## Llama view

From llama-server, these show up as separate MCP servers:

- `mcp-time`
- `ddg-search`
- `mcp-fetch`
- `github-mcp-server`

## Config

The current [config.json](config.json) uses:

- `time` via `python -m mcp_server_time --local-timezone=Europe/Sofia`
- `ddg-search` via `uvx duckduckgo-mcp-server`
- `fetch` via `python -m mcp_server_fetch`
- `github` via `mcp-server-github`

## Run

Use [run.bat](run.bat) to start the local launcher.
