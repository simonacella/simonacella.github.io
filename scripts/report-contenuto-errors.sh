# Shared snippet: after a failed jekyll build, publish Italian content errors
# to the Actions Job Summary (and a single ::error annotation).
# Expects /tmp/jekyll-build.log from the build step and optional contenuto-errori.md.

set -euo pipefail

{
  echo "## Pubblicazione interrotta"
  echo ""
  if [ -f contenuto-errori.md ]; then
    cat contenuto-errori.md
  elif grep -q "Contenuto:" /tmp/jekyll-build.log 2>/dev/null; then
    echo "Dettaglio dagli errori di build:"
    echo ""
    echo '```'
    grep "Contenuto:" /tmp/jekyll-build.log || true
    echo '```'
  elif grep -q "YAML Exception" /tmp/jekyll-build.log 2>/dev/null; then
    echo "Errore YAML nel blocco in alto di un articolo o in un file \`.yml\`."
    echo ""
    echo "Controlla le \`---\`, le virgolette intorno a \`description\` e l'indentazione."
    echo ""
    echo '```'
    grep -A2 "YAML Exception" /tmp/jekyll-build.log || true
    echo '```'
  else
    echo "La build è fallita. Apri il log del passo **Build with Jekyll** per i dettagli."
  fi
} >> "$GITHUB_STEP_SUMMARY"

echo "::error::Pubblicazione interrotta: apri la Summary di questo run (Actions) per l'elenco degli errori e come correggerli."
