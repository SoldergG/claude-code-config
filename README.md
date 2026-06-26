# Config do Claude Code — pacote para partilhar

Tudo o que precisas para teres o mesmo setup: a **barra de estado** (aquilo em baixo do
terminal com o modelo, % de contexto, branch, rate limits), as **skills**, os **plugins**,
os **MCP servers** e as **settings**.

> Feito para **macOS**. A statusline usa comandos do macOS (`date -j`, `security`).
> No Linux há partes que precisam de ajuste.

---

## Instalação rápida

```bash
# 1) extrai a pasta e entra nela
cd claude-config-share

# 2) corre o instalador (copia skills + statusline + settings)
bash install.sh
```

Depois faz os **passos manuais** em baixo (plugins + MCP). No fim, **reinicia o Claude Code**.

Pré-requisito: `jq` (a statusline não funciona sem ele).
```bash
brew install jq
```

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

A `statusline.sh` mostra, **linha 1**: modelo · % de contexto usado · pasta `(branch*)` (o `*`
quer dizer alterações por commitar) · duração da sessão · nível de esforço.
**Linha 2/3**: os teus *rate limits* — `current` (janela de 5h) e `weekly` (7 dias), com a hora
de reset. Vai buscar isto à API da Anthropic com o teu próprio token OAuth (lê-o do Keychain do
macOS) e faz cache 60s em `/tmp/claude`. Não há nenhum segredo dentro do script — usa o login
de cada um.

A ligação no `settings.json` é:
```json
"statusLine": { "type": "command", "command": "bash \"$HOME/.claude/statusline.sh\"" }
```

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
(grátis em https://21st.dev). A chave do Lucas **não** vai no pacote.
```bash
claude mcp add magic -- npx -y @21st-dev/magic@latest
# depois mete a env API_KEY=<a_tua_chave> (em ~/.claude.json no server "magic")
```

**Apple Calendar** — lê/cria eventos no Calendário do macOS.
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
