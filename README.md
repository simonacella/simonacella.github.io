## Markdown
- [Sintassi di base (GitHub)](https://docs.github.com/en/get-started/writing-on-github/getting-started-with-writing-and-formatting-on-github/basic-writing-and-formatting-syntax)
- [Guida Markdown](https://www.markdownguide.org/basic-syntax/)

## Progetto
Backend di https://simonacella.github.io/ (tema Jekyll [Adam Blog 2.0](https://github.com/the-mvm/the-mvm.github.io)).

## Nuovo articolo — cosa compilare

Copia un post esistente in `_posts/` e aggiorna il blocco iniziale:

```yaml
---
layout: post
title: Titolo dell’articolo
date: 2025-08-20
img: posts/nome-immagine.jpg
tags: [Regista, Paese, Cinema]
category: Cinema
author: Simona Cella
description: Una o due frasi che riassumono l’articolo (140–160 caratteri).
publisher: Nigrizia
publication_link: https://www.nigrizia.it/...
---
```

| Campo | Regola |
|-------|--------|
| `date` | Data reale di pubblicazione (`AAAA-MM-GG`), non l’anno del film |
| `description` | Riassunto in 1–2 frasi, non etichette tipo «Recensione di…» |
| `author` | Di solito `Simona Cella` |
| `img` | File in `assets/img/posts/`, nome **senza spazi** |
| `publisher` + `publication_link` | Solo se già uscito altrove; **entrambi** o nessuno |
| Nome file | `AAAA-MM-GG-Titolo-Breve.md` — senza spazi (diventa l’URL) |

**Opzionale:** `last_modified_at: AAAA-MM-GG` se aggiorni un articolo già pubblicato.  
**Prima di pubblicare:** chiusura `---` · `description` utile · immagine al percorso giusto · nessun spazio nel nome file.
