"""Regression tests for the Windows batch launcher."""

from __future__ import annotations

from pathlib import Path


def test_run_bat_uses_script_directory_for_local_paths() -> None:
    """run.bat should resolve config and Python imports from its own folder."""
    run_bat = Path(__file__).resolve().parents[1] / "run.bat"
    content = run_bat.read_text(encoding="utf-8")

    assert 'set "SCRIPT_DIR=%~dp0"' in content
    assert 'set "PYTHONPATH=%SCRIPT_DIR%src;%PYTHONPATH%"' in content
    assert 'python -m mcp_proxy --named-server-config "%SCRIPT_DIR%config.json"' in content
    assert r'set Path=%USERPROFILE%\.local\bin;!Path!' in content
    assert 'C:\\Users\\E0099460' not in content