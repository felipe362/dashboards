#!/bin/zsh
# Observa mudanças na pasta HTMLS e chama o sync
FOLDER="/Users/felip/Desktop/HTMLS"
SYNC="$FOLDER/.sync/sync.sh"

/opt/homebrew/bin/fswatch -0 -r \
  --exclude "\.git" \
  --exclude "\.sync" \
  --exclude "\.DS_Store" \
  --exclude "\.tmp$" \
  "$FOLDER" | while IFS= read -r -d '' event; do
    sleep 2  # Aguarda salvar completamente
    zsh "$SYNC"
done
