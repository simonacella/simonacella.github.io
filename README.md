# Guida per gestire i contenuti del sito

Sito: https://simonacella.github.io/

Questa guida serve per pubblicare articoli **e** per aggiornare le altre parti del sito che cambiano di tanto in tanto: la tua biografia, i contatti, la foto profilo, la descrizione del sito. Non serve saper programmare: bastano gli esempi qui sotto, copiati e adattati con attenzione.

## Indice

- [Prima di iniziare: 3 regole per non rompere nulla](#prima-di-iniziare-3-regole-per-non-rompere-nulla)
- [Pubblicare un nuovo articolo](#pubblicare-un-nuovo-articolo)
- [Il blocco in alto dell'articolo (obbligatorio)](#il-blocco-in-alto-dellarticolo-obbligatorio)
- [Come formattare il testo](#come-formattare-il-testo)
- [Niente spazi nei nomi dei file](#niente-spazi-nei-nomi-dei-file)
- [Tradurre un articolo (inglese o francese)](#tradurre-un-articolo-inglese-o-francese)
- [Modificare la tua biografia](#modificare-la-tua-biografia)
- [Modificare titolo e descrizione del sito](#modificare-titolo-e-descrizione-del-sito)
- [Modificare i contatti e la foto profilo](#modificare-i-contatti-e-la-foto-profilo)
- [Tradurre le etichette dei tag (avanzato, facoltativo)](#tradurre-le-etichette-dei-tag-avanzato-facoltativo)
- [Controllo prima di pubblicare](#controllo-prima-di-pubblicare)

## Prima di iniziare: 3 regole per non rompere nulla

I file che modifichi (quelli con estensione `.yml` o il blocco in alto degli articoli) usano un formato chiamato **YAML**. È solo testo, ma è sensibile a tre cose. Tienile a mente ogni volta che modifichi qualcosa fuori da un articolo:

**1. Gli spazi all’inizio della riga contano.** Se una riga che modifichi inizia con 2 spazi, la tua modifica deve restare con quegli stessi 2 spazi. Non usare il tasto Tab.

```yaml
# Sì
it:
  about_author: "Sceneggiatrice, produttrice, critica cinematografica"

# No — manca l'indentazione, il file si rompe
it:
about_author: "Sceneggiatrice, produttrice, critica cinematografica"
```

**2. I due punti dentro un testo vanno protetti con le virgolette.** Se scrivi un testo che contiene `:`, mettilo tra virgolette `"…"`, altrimenti la pagina non si genera più.

```yaml
# Sì
description: "Il regista: un ritratto"

# No
description: Il regista: un ritratto
```

**3. Copia una riga esistente, non inventarla da zero.** Il modo più sicuro per aggiungere o modificare una riga è copiarne una simile già presente nel file e cambiare solo le parole, lasciando invariati virgolette, due punti, trattini e spazi intorno.

Un’ultima cosa: alcuni file (`_data/site-text.yml`, `_data/ui-text.yml`, `_data/tag-labels.yml`) contengono **tre sezioni**, una per lingua: `it:`, `en:` e `fr:`. Modifica solo la sezione della lingua che ti interessa; le altre restano come sono finché non hai una traduzione pronta.

## Pubblicare un nuovo articolo

1. Nella cartella `_posts/`, **copia** un articolo già pubblicato (ad esempio `Dahomey`).
2. **Rinomina** la copia con data + titolo breve, **senza spazi** (usa i trattini `-`):
   - Bene: `2025-09-15-Titolo-del-Film.md`
   - No: `2025-09-15 Titolo del Film.md`
3. Apri il file e aggiorna il **blocco in alto** (tra le due righe `---`).
4. Sotto il secondo `---`, scrivi (o incolla) il testo dell’articolo.
5. Metti le immagini nella cartella `assets/img/posts/` e collegale come negli articoli già online. Puoi caricarle così come sono (anche se pesanti): il sito crea automaticamente versioni più leggere in pubblicazione. Non serve ridimensionarle a mano. Su GitHub ogni file deve restare sotto i **100 MB** (limite della piattaforma).

## Il blocco in alto dell'articolo (obbligatorio)

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

Per i sottotitoli usa sempre `##` (due cancelletti), non `###`.

Se ti serve un ripasso: [guida Markdown di GitHub](https://docs.github.com/en/get-started/writing-on-github/getting-started-with-writing-and-formatting-on-github/basic-writing-and-formatting-syntax) · [altra guida](https://www.markdownguide.org/basic-syntax/)

## Niente spazi nei nomi dei file

Vale per il file dell’articolo **e** per tutte le immagini (copertina e foto nel testo), sia per gli articoli sia per la foto profilo.

| No | Sì |
|----|-----|
| `Intervista a Boris Lojkine.md` | `Intervista-a-Boris-Lojkine.md` |
| `furto spada.jpg` | `furto-spada.jpg` |

Se rinomini un’immagine, aggiorna anche il nome dove compare nel blocco in alto (`img:`, `author-pic:`) o nel testo.

## Tradurre un articolo (inglese o francese)

Il sito può pubblicare la stessa pagina in italiano, inglese e francese.
L’italiano resta l’originale; le altre lingue si aggiungono **solo quando la traduzione è pronta**.

1. **Copia** il file dell’articolo in `_posts/` (stesso nome + suffisso, es. `…-Touki-Bouki.en.md`).
2. Nel blocco in alto della **copia**:
   - `lang: en` oppure `lang: fr`
   - lo stesso `permalink:` dell’originale (es. `permalink: Touki-Bouki.html`), così i due file restano collegati
3. Traduci `title`, `description` e il testo sotto il blocco.
4. **Non cambiare** i `tags:`: restano in italiano (compaiono tradotti nel menu dove serve, vedi [Tradurre le etichette dei tag](#tradurre-le-etichette-dei-tag-avanzato-facoltativo)).

L’articolo italiano può restare senza `lang`, oppure con `lang: it`. Finché non esiste la traduzione, le pagine `/en/` e `/fr/` mostrano ancora il testo italiano — non è un errore, è previsto.

## Modificare la tua biografia

La tua biografia vive nel file `_data/site-text.yml`, in tre versioni (`it:`, `en:`, `fr:`). Cerca il blocco della lingua che vuoi aggiornare:

```yaml
it:
  about_author: "Sceneggiatrice, produttrice, critica cinematografica"
  about_author_long: |
    Esperta di cinema africano e terzo cinema, dopo una lunga esperienza nel mondo della produzione
    cinematografica e dell’organizzazione culturale, si è specializzata...
```

- `about_author` è la riga breve che appare vicino alle icone di contatto, in fondo agli articoli. Tienila corta e tra virgolette.
- `about_author_long` è il testo lungo della pagina «Chi sono». Attenzione a due cose:
  - la barra verticale `|` subito dopo i due punti **non va toccata**: dice al sito «tutto il testo indentato qui sotto è un unico paragrafo».
  - ogni riga del testo deve restare indentata come le righe intorno (di solito 4 spazi): se scrivi da un editor di testo semplice, la cosa più sicura è modificare le frasi esistenti invece di aggiungere righe nuove, oppure incollare il nuovo testo mantenendo lo stesso rientro.

Per aggiornare la versione inglese o francese, scorri fino al blocco `en:` o `fr:` e modifica le stesse due righe lì. Se non hai ancora una traduzione, lascia il testo com’è: è meglio di una traduzione a metà o di una riga vuota.

## Modificare titolo e descrizione del sito

- **Titolo** (`Il cinema come amuleto`): è il nome del sito e non va tradotto nelle altre lingue. Si trova in cima a `_config.yml`, riga `title:`. Cambialo solo se sei sicura: appare ovunque (scheda del browser, anteprime social, intestazione del sito).
- **Descrizione breve** (quella sotto il titolo, usata anche da Google e dai social): appare in **due file**, e per l’italiano vanno tenuti uguali:
  - `_config.yml`, riga `description:` (in cima al file)
  - `_data/site-text.yml`, blocco `it:`, riga `description:`
  
  Per le versioni inglese e francese, modifica solo `_data/site-text.yml`, nei blocchi `en:` e `fr:`.

## Modificare i contatti e la foto profilo

Si trovano in cima a `_config.yml`, nelle sezioni «Author settings» e «Contact links»:

```yaml
author: Simona Cella
author-pic: assets/img/Myself.jpeg

email: simona.reichmann@gmail.com
website: https://simonacella.github.io
linkedin: simona-cella-a531b4b/
github:  simonacella
facebook: simona.cella.9
instagram: simona_reichmann
imdb: nm7677685
```

| Campo | Cosa scrivere |
|-------|----------------|
| `author` | Il tuo nome, così come deve apparire sul sito |
| `author-pic` | Percorso della foto profilo, es. `assets/img/nome-file.jpeg` — carica prima la foto in `assets/img/` (nome file senza spazi) |
| `email` | Il tuo indirizzo email |
| `website` | Il link completo al sito |
| `linkedin`, `instagram`, `facebook` | Solo il tuo nome utente/handle, **non** il link intero (guarda gli esempi sopra) |
| `github` | Il tuo nome utente GitHub |
| `imdb` | Il tuo codice IMDb (inizia con `nm`) |

Per **togliere** un contatto (es. non usi più Facebook), cancella l’intera riga: l’icona sparisce automaticamente dal sito. Per aggiungerne uno nuovo, copia una riga simile e sostituisci nome del campo e valore.

Non serve tradurre questi campi: sono uguali in tutte le lingue.

## Tradurre le etichette dei tag (avanzato, facoltativo)

I `tags:` che scrivi negli articoli (es. `Migrazione`, `Francia`) restano **sempre in italiano** anche nelle pagine inglese e francese: sono usati per collegare gli articoli tra loro e non vanno cambiati lì.

Se però vuoi che un tag venga **mostrato** tradotto quando qualcuno legge il sito in inglese o francese, aggiungilo in `_data/tag-labels.yml`:

```yaml
en:
  Migrazione: "Migration"

fr:
  Migrazione: "Migration"
```

Regole pratiche:

- A sinistra dei due punti va **esattamente** il tag come lo scrivi negli articoli (stessa maiuscola/minuscola).
- A destra, tra virgolette, va la traduzione da mostrare.
- Nomi propri (persone, paesi, registi) di solito non hanno bisogno di traduzione: aggiungi qui solo le parole che cambiano davvero (es. «Migrazione» → «Migration»).
- Se non sei sicura, lascia perdere questo file: il tag continuerà a comparire in italiano, che non è un errore.

## Controllo prima di pubblicare

- [ ] Le due righe `---` ci sono, all’inizio e alla fine del blocco dell’articolo
- [ ] `description` è un vero riassunto (non un’etichetta corta) e sta tra virgolette `"…"`
- [ ] Le immagini esistono nella cartella e i nomi nel testo coincidono
- [ ] Nessuno spazio nei nomi di file o immagini
- [ ] Se c’è una versione su Nigrizia (o altro): sia `publisher` sia `publication_link`
- [ ] Se hai modificato bio, contatti o descrizione del sito: hai lavorato nel file giusto e nella lingua giusta?
- [ ] Le righe che hai copiato hanno ancora le stesse virgolette, due punti e spazi iniziali dell’originale?
