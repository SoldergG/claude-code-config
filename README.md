# Config do Claude Code — pacote para partilhar

Tudo o que precisas para teres o mesmo setup: a **barra de estado** (aquilo em baixo do
terminal com o modelo, % de contexto, branch, rate limits), as **skills**, os **plugins**,
os **MCP servers** e as **settings**.

Funciona em **macOS**, **Linux**, **WSL** e **Git Bash (Windows)**.

---

## Instalação rápida

```bash
# 1) clona o repo
git clone https://github.com/SoldergG/claude-code-config.git
cd claude-code-config

# 2) corre o instalador (copia skills + statusline + settings)
bash install.sh
```

Depois faz os **passos manuais** em baixo (plugins + MCP). No fim, **reinicia o Claude Code**.

### Pré-requisitos

| Plataforma | Pré-requisito |
|---|---|
| macOS | `brew install jq` |
| Linux / WSL | `sudo apt install jq curl` (ou equivalente) |
| Git Bash (Windows) | instala [jq para Windows](https://jqlang.github.io/jq/download/) + [curl](https://curl.se/windows/) |

---

## O que vem na caixa

| Ficheiro | O que é |
|---|---|
| `settings.json` | vai para `~/.claude/settings.json` (modelo, esforço, statusline, plugins, notificações) |
| `statusline.sh` | a barra de estado custom → `~/.claude/statusline.sh` |
| `skills/` | 25 skills → `~/.claude/skills/` |
| `mcp-servers.json` | os MCP locais (referência; instala-se à mão) |
| `install.sh` | copia skills + statusline + settings automaticamente |

---

## 1. A barra de estado (statusline)

É aquilo que vês por baixo do prompt:

```
Opus 4.8 │ ✍️ 0% │ S+Go (sgo-main*) │ ● high
current ●●●●●●●○○○  76% ⟳ 9:30pm
weekly  ●●●●●●○○○○  60% ⟳ jun 28, 6:00am
```

**Linha 1:** modelo · % de contexto usado · pasta `(branch*)` (`*` = alterações por commitar)
· duração da sessão · nível de esforço.

**Linha 2/3:** os teus *rate limits* — `current` (janela de 5h) e `weekly` (7 dias), com a
hora de reset. Vai buscar isto à API da Anthropic com o teu próprio token OAuth e faz cache
60s em `/tmp/claude`. Não há nenhum segredo dentro do script — usa o login de cada um.

A ligação no `settings.json` é:
```json
"statusLine": { "type": "command", "command": "bash \"$HOME/.claude/statusline.sh\"" }
```

### Compatibilidade da statusline

| Plataforma | Credenciais | `date` |
|---|---|---|
| macOS | Keychain (`security`) | `date -j` (nativo) |
| Linux | `secret-tool` (GNOME) ou ficheiro | GNU `date` |
| WSL | ficheiro `~/.claude/.credentials.json` | GNU `date` |
| Git Bash (Windows) | Windows Credential Manager (PowerShell) ou ficheiro | GNU `date` via MSYS |

Em qualquer plataforma, se já fizeste `claude login`, as credenciais ficam em
`~/.claude/.credentials.json` e a statusline lê-as automaticamente.

### Windows: configurar o Claude Code para usar o `bash` da statusline

No Windows, o Claude Code precisa de saber onde está o `bash`. Há duas opções:

**Opção A — WSL (recomendado):** Corre o Claude Code dentro do terminal WSL. A statusline
funciona nativamente sem configuração extra.

**Opção B — Git Bash / MSYS:** A `settings.json` já tem `bash "$HOME/.claude/statusline.sh"`.
O Claude Code no Windows usa o `bash` do PATH — garante que o Git Bash está no PATH (normalmente
está se instalaste o Git for Windows).

---

## 2. settings.json (explicado)

```json
{
  "statusLine": { ... },                  // liga a barra de estado de cima
  "enabledPlugins": {                      // liga os 3 plugins (instala-os primeiro, ver secção 4)
    "swift-lsp@claude-plugins-official": true,
    "frontend-design@claude-plugins-official": true,
    "vercel@claude-plugins-official": true
  },
  "effortLevel": "high",                   // o "● high" — mais raciocínio (low/medium/high)
  "tui": "fullscreen",                     // terminal em ecrã inteiro
  "model": "opus",                         // modelo por omissão (Opus)
  "remoteControlAtStartup": true,          // o "/rc active" — controlo remoto da app
  "inputNeededNotifEnabled": true,         // notifica quando precisa de ti
  "agentPushNotifEnabled": true,           // push quando um agente acaba
  "voice": { "enabled": false },
  "voiceEnabled": false
}
```

Para mudanças simples (tema, modelo) também dá para usar `/config` dentro do Claude.

> O `-- INSERT --` que vês é o **modo vim** do editor de input. Liga-o dentro do Claude com
> `/vim` (ou em `/config`). Não é uma setting deste ficheiro.

---

## 3. Skills (25)

Ficam em `~/.claude/skills/` (o `install.sh` já as copia). Lista:

**Design / Frontend**
`design-taste-frontend` · `design-taste-frontend-v1` · `high-end-visual-design` ·
`impeccable` · `redesign-existing-projects` · `minimalist-ui` · `industrial-brutalist-ui` ·
`ui-ux-pro-max` · `gpt-taste` · `stitch-design-taste` · `huashu-design`

**Geração de imagens (design)**
`imagegen-frontend-web` · `imagegen-frontend-mobile` · `image-to-code` · `brandkit`

**3D / Vídeo**
`3d-web-experience` · `threejs` · `threejs-skills` · `remotion-best-practices`

**Swift / iOS**
`do-lang-swift` · `moai-lang-swift`

**Utilitárias**
`find-skills` (descobre/instala skills) · `full-output-enforcement` · `grill-me` · `template`

Para descobrir/instalar mais no futuro, dentro do Claude usa a skill `find-skills` ou escreve
`/` para ver as disponíveis.

---

## 4. Plugins (passo manual)

Os 3 plugins vêm do marketplace oficial. Dentro do Claude Code:

```
/plugin
```
1. Adiciona o marketplace: `anthropics/claude-plugins-official`
2. Instala: **swift-lsp**, **frontend-design**, **vercel**

O `settings.json` já os deixa marcados como `enabled` — só tens mesmo de os instalar.

---

## 5. MCP servers (passo manual)

Dois servidores locais. Instala-os com `claude mcp add` (ou cola o bloco do
`mcp-servers.json` em `~/.claude.json` na chave `mcpServers`).

**Magic (21st.dev)** — gera componentes de UI. Precisas da **tua própria** API key
(grátis em https://21st.dev).
```bash
claude mcp add magic -- npx -y @21st-dev/magic@latest
# depois mete a env API_KEY=<a_tua_chave> (em ~/.claude.json no server "magic")
```

**Apple Calendar** — lê/cria eventos no Calendário do macOS (macOS apenas).
```bash
claude mcp add apple-calendar -- npx apple-calendar-mcp
```

> Há ainda dezenas de MCP "claude.ai" (Notion, Gmail, Supabase, Shopify, Vercel, etc.) que
> aparecem ligados — mas esses são conectores da **conta claude.ai** (ligas via OAuth no site
> claude.ai, não via este ficheiro). Cada um liga os que quiser na própria conta.

---

## Resumo do que é automático vs. manual

| | Automático (`install.sh`) | Manual |
|---|---|---|
| Skills | ✅ | — |
| Statusline | ✅ | — |
| settings.json | ✅ (com backup) | — |
| Plugins | — | `/plugin` |
| MCP | — | `claude mcp add` + a tua API key |
| Modo vim | — | `/vim` dentro do Claude |

Qualquer dúvida, dentro do Claude Code corre `/help`.
