# Guida per pubblicare un articolo

Sito: https://simonacella.github.io/

## Come creare un nuovo articolo

1. Nella cartella `_posts/`, **copia** un articolo già pubblicato (ad esempio `Dahomey`).
2. **Rinomina** la copia con data + titolo breve, **senza spazi** (usa i trattini `-`):
   - Bene: `2025-09-15-Titolo-del-Film.md`
   - No: `2025-09-15 Titolo del Film.md`
3. Apri il file e aggiorna il **blocco in alto** (tra le due righe `---`).
4. Sotto il secondo `---`, scrivi (o incolla) il testo dell’articolo.
5. Metti le immagini nella cartella `assets/img/posts/` e collegale come negli articoli già online.

## Il blocco in alto (obbligatorio)

È l’intestazione dell’articolo. Compila ogni riga; non cancellare le `---` di apertura e chiusura.

```yaml
---
layout: post
title: Titolo dell’articolo
date: 2025-08-20
img: posts/nome-immagine.jpg
tags: [Regista, Paese, Cinema]
category: Cinema
author: Simona Cella
description: "Una o due frasi che riassumono l’articolo."
publisher: Nigrizia
publication_link: https://www.nigrizia.it/...
---
```

Cosa mettere in ciascun campo:

| Campo | Cosa scrivere |
|-------|----------------|
| `layout` | Lascia sempre `post` |
| `title` | Il titolo che si vede sulla pagina |
| `date` | Data di **pubblicazione sul sito**, formato `2025-08-20` (non l’anno del film) |
| `img` | Nome della copertina, già salvata in `assets/img/posts/` — es. `posts/dahomey.jpg` |
| `tags` | Parole chiave tra parentesi quadre, separate da virgole |
| `category` | Una categoria, es. `Cinema`, `Intervista`, `Esposizione` |
| `author` | Di solito `Simona Cella` |
| `description` | **Riassunto in 1–2 frasi** (circa 140–160 caratteri), **sempre tra virgolette** `"…"`. Serve a Google e alle anteprime sui social. Non scrivere solo «Recensione di…» o «Intervista a…». Senza virgolette, i due punti (`:`) nel testo rompono la pagina |
| `publisher` | Solo se l’articolo è già uscito altrove (es. `Nigrizia`) |
| `publication_link` | Solo in quel caso: link completo all’articolo originale (`https://…`) |

Se non è uscito altrove, **cancella** le righe `publisher` e `publication_link`.

Se **modifichi** un articolo già online, puoi aggiungere:
`last_modified_at: 2025-09-15`

## Come formattare il testo

Sotto il blocco in alto si scrive in **Markdown**: bastano pochi segni intorno alle parole.

| Vuoi… | Scrivi così |
|-------|-------------|
| Un sottotitolo | `## Titolo della sezione` |
| Grassetto | `**parola**` |
| Corsivo | `_parola_` |
| Un link | `[testo del link](https://esempio.it)` |
| Un’immagine | `![breve descrizione](./assets/img/posts/nome-immagine.jpg)` |

Per i sottotitoli usa sempre `##` (due cancelleti), non `###`.

Se ti serve un ripasso: [guida Markdown di GitHub](https://docs.github.com/en/get-started/writing-on-github/getting-started-with-writing-and-formatting-on-github/basic-writing-and-formatting-syntax) · [altra guida](https://www.markdownguide.org/basic-syntax/)

## Niente spazi nei nomi dei file

Vale per il file dell’articolo **e** per tutte le immagini (copertina e foto nel testo).

| No | Sì |
|----|-----|
| `Intervista a Boris Lojkine.md` | `Intervista-a-Boris-Lojkine.md` |
| `furto spada.jpg` | `furto-spada.jpg` |

Se rinomini un’immagine, aggiorna anche il nome dove compare nel blocco in alto (`img:`) o nel testo.

## Controllo prima di pubblicare

- [ ] Le due righe `---` ci sono, all’inizio e alla fine del blocco
- [ ] `description` è un vero riassunto (non un’etichetta corta) e sta tra virgolette `"…"`
- [ ] Le immagini esistono nella cartella e i nomi nel testo coincidono
- [ ] Nessuno spazio nei nomi di file o immagini
- [ ] Se c’è una versione su Nigrizia (o altro): sia `publisher` sia `publication_link`
