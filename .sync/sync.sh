#!/bin/zsh
# Auto-sync HTMLS → GitHub
FOLDER="/Users/felip/Desktop/HTMLS"
LOG="$FOLDER/.sync/sync.log"
LOCK="$FOLDER/.sync/sync.lock"

log() { echo "[$(date '+%Y-%m-%d %H:%M:%S')] $1" >> "$LOG"; }

# Evitar execuções simultâneas
if [ -f "$LOCK" ]; then exit 0; fi
touch "$LOCK"
trap "rm -f '$LOCK'" EXIT

cd "$FOLDER" || exit 1

# Verificar se há mudanças locais
if git diff --quiet && git diff --cached --quiet && [ -z "$(git ls-files --others --exclude-standard)" ]; then
  rm -f "$LOCK"; exit 0
fi

# Commit local (funciona mesmo sem internet)
git add -A
CHANGED=$(git diff --cached --name-only | head -5 | tr '\n' ', ' | sed 's/,$//')
git commit -m "Auto: $CHANGED — $(date '+%d/%m %H:%M')" >> "$LOG" 2>&1

# Tentar push (só se tiver internet)
if ping -c 1 -t 3 github.com > /dev/null 2>&1; then
  git push origin main >> "$LOG" 2>&1 && log "✅ Sincronizado com GitHub" || log "⚠️ Erro no push"
else
  log "📴 Offline — alterações salvas localmente, serão enviadas quando houver internet"
fi
