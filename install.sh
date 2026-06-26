#!/bin/bash
# ─────────────────────────────────────────────────────────────
#  Instalador da config do Claude Code (skills + statusline + settings)
#  Corre:  bash install.sh
# ─────────────────────────────────────────────────────────────
set -e
HERE="$(cd "$(dirname "$0")" && pwd)"
DEST="$HOME/.claude"

echo "==> A instalar config do Claude Code em $DEST"
mkdir -p "$DEST/skills"

# 1) Dependencia: jq (necessario para a statusline)
if ! command -v jq >/dev/null 2>&1; then
  echo "!! 'jq' nao esta instalado. Instala com:  brew install jq   (depois corre isto outra vez)"
  exit 1
fi

# 2) Skills
echo "==> A copiar $(ls -1 "$HERE/skills" | wc -l | tr -d ' ') skills..."
cp -R "$HERE/skills/." "$DEST/skills/"

# 3) Statusline
echo "==> A instalar a statusline..."
cp "$HERE/statusline.sh" "$DEST/statusline.sh"
chmod +x "$DEST/statusline.sh"

# 4) settings.json  (faz backup se ja existir)
if [ -f "$DEST/settings.json" ]; then
  cp "$DEST/settings.json" "$DEST/settings.json.bak.$(date +%s)"
  echo "==> settings.json existente guardado como backup."
fi
cp "$HERE/settings.json" "$DEST/settings.json"

echo ""
echo "✔ Skills, statusline e settings instalados."
echo ""
echo "PASSOS MANUAIS QUE FALTAM (ver README.md):"
echo "  1. Plugins:   abre o claude e corre   /plugin   -> marketplace anthropics/claude-plugins-official"
echo "                instala: swift-lsp, frontend-design, vercel"
echo "  2. MCP:       claude mcp add ...   (ver mcp-servers.json + README)"
echo "  3. Reinicia o claude para a statusline e settings entrarem."
