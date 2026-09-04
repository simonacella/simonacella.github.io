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
- [Anteprima delle lingue (senza annunciarlo)](#anteprima-delle-lingue-senza-annunciarlo)
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

**2. La `description` va sempre tra virgolette `"…"`.** È testo libero: senza virgolette, certi caratteri possono far fallire la generazione della pagina. Meglio metterle sempre, anche «per sicurezza».

```yaml
# Sì
description: "Il regista: un ritratto"

# No
description: Il regista: un ritratto
```

**3. Copia una riga esistente, non inventarla da zero.** Il modo più sicuro per aggiungere o modificare una riga è copiarne una simile già presente nel file e cambiare solo le parole, lasciando invariati virgolette, due punti, trattini e spazi intorno.

Un’ultima cosa: alcuni file (`_data/site-text.yml`, `_data/ui-text.yml`) contengono **tre sezioni**, una per lingua: `it:`, `en:` e `fr:`. Modifica solo la sezione della lingua che ti interessa; le altre restano come sono finché non hai una traduzione pronta. `_data/tag-labels.yml` fa eccezione: ha solo le sezioni `en:` e `fr:`, perché in italiano i tag si mostrano già così come li scrivi negli articoli.

## Pubblicare un nuovo articolo

1. Nella cartella `_posts/`, **copia** un articolo già pubblicato (ad esempio `Dahomey`).
2. **Rinomina** la copia con data + titolo breve, **senza spazi** (usa i trattini `-`):
   - Bene: `2025-09-15-Titolo-del-Film.md`
   - No: `2025-09-15 Titolo del Film.md`
3. Apri il file e aggiorna il **blocco in alto** (tra le due righe `---`).
4. Sotto il secondo `---`, scrivi (o incolla) il testo dell’articolo.
5. Metti le immagini nella cartella `assets/img/posts/` e collegale nel testo come nella tabella qui sotto. Puoi caricarle così come sono (anche se pesanti): il sito crea automaticamente versioni più leggere in pubblicazione. Non serve ridimensionarle a mano. Su GitHub ogni file deve restare sotto i **100 MB** (limite della piattaforma).

## Il blocco in alto dell'articolo (obbligatorio)

È l’intestazione dell’articolo. Compila ogni riga; non cancellare le `---` di apertura e chiusura.

```yaml
---
title: Titolo dell’articolo
lang: it
date: 2025-08-20
img: /assets/img/posts/nome-immagine.jpg
tags: [Regista, Paese, Cinema]
description: "Una o due frasi che riassumono l’articolo."
publisher: Nigrizia
publication_link: https://www.nigrizia.it/...
---
```

Cosa mettere in ciascun campo:

| Campo | Cosa scrivere |
|-------|----------------|
| `title` | Il titolo che si vede sulla pagina |
| `lang` | Lingua dell’articolo: `it` per l’italiano; nelle traduzioni `en` o `fr` |
| `date` | Data di **pubblicazione sul sito**, formato `2025-08-20` (non l’anno del film) |
| `img` | Percorso della copertina in `assets/img/posts/` — es. `/assets/img/posts/dahomey.jpg` |
| `tags` | Parole chiave tra parentesi quadre, separate da virgole |
| `description` | **Riassunto in 1–2 frasi** (circa 140–160 caratteri), **sempre tra virgolette** `"…"`. Serve a Google e alle anteprime sui social. Non scrivere solo «Recensione di…» o «Intervista a…». Le virgolette vanno sempre, per sicurezza |
| `publisher` | Solo se l’articolo è già uscito altrove (es. `Nigrizia`) |
| `publication_link` | Solo in quel caso: link completo all’articolo originale (`https://…`) |

Se non è uscito altrove, **cancella** le righe `publisher` e `publication_link`.

Il nome dell’autrice e il tipo di pagina (articolo) vengono dal sito, non vanno ripetuti in ogni file.

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
| Un’immagine | `![breve descrizione](/assets/img/posts/nome-immagine.jpg)` |
| Un’immagine con didascalia | vedi esempio sotto |
| Un video YouTube | `{% youtube "https://youtu.be/CODICE" %}` |

Per le immagini nel testo, il percorso deve iniziare con `/assets/…` (una sola barra all’inizio).

Per inserire un **video YouTube**, copia una riga già usata in un articolo recente e cambia solo l’indirizzo tra virgolette. Vanno bene i link corti `youtu.be/…` e quelli lunghi `youtube.com/watch?v=…`. Se l’indirizzo è sbagliato, in pubblicazione compare un avviso e il video non viene mostrato — non è un errore silenzioso.

Per aggiungere una **didascalia** (testo centrato, in corsivo e più piccolo sotto la foto), copia questo schema dall’articolo *Soundtrack to a coup d’état*. La seconda riga deve stare **subito sotto** l’immagine, senza righe vuote in mezzo:

```
![hotel teresa](/assets/img/posts/hotelteresa.jpg)
<small>Fidel Castro e Malcolm X all’Hotel Theresa, Harlem, settembre 1960</small>
```

Il testo tra `![` e `]` è la descrizione per chi non vede l’immagine; la riga con `small` è il testo visibile sotto la foto. Cambia entrambi quando riusi lo schema in un altro articolo.

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

1. **Copia** il file dell’articolo in `_posts/`.
2. **Rinomina** la copia aggiungendo `.en` o `.fr` prima di `.md` (**stessa data e stesso nome** — così le versioni condividono lo stesso indirizzo):
   - Originale: `2024-01-15-Touki-Bouki.md`
   - Inglese: `2024-01-15-Touki-Bouki.en.md`
   - Francese: `2024-01-15-Touki-Bouki.fr.md`
3. Nel blocco in alto della copia, cambia `lang: it` in `lang: en` oppure `lang: fr`.
4. Traduci `title:` (se serve), `description` e il testo sotto il blocco.
5. **Non cambiare** i `tags:`: restano in italiano (compaiono tradotti nel menu dove serve, vedi [Tradurre le etichette dei tag](#tradurre-le-etichette-dei-tag-avanzato-facoltativo)).

Finché non crei il file `.en.md` o `.fr.md`, quell’articolo non compare nelle versioni inglese o francese — non è un errore, è previsto.

### Anteprima delle lingue (senza annunciarlo)

I pulsanti IT / EN / FR **non compaiono** sulle pagine italiane finché le traduzioni non sono pronte da mostrare a tutti.

Per controllare inglese o francese: apri il sito aggiungendo `/en/` o `/fr/` dopo il nome del sito, per esempio:
- `https://simonacella.github.io/en/`
- `https://simonacella.github.io/fr/about.html`

Lì compaiono i pulsanti per passare da una lingua all’altra. Quando è il momento di annunciare le traduzioni, in `_config.yml` cambia `lang_switcher_public: false` in `true`.

## Modificare la tua biografia

Dal CMS: **Pagine → Chi sono** (italiano / inglese / francese). In alternativa, modifica `_data/about.yml` a mano:

```yaml
it:
  title: "Chi sono"
  description: "Profilo di Simona Cella…"
  about_author: "Sceneggiatrice, produttrice, critica cinematografica"
  about_author_long: |
    Esperta di cinema africano e terzo cinema…
```

- `about_author` è la riga breve vicino alle icone di contatto, in fondo agli articoli. Tienila corta.
- `about_author_long` è il testo lungo della pagina «Chi sono» (Markdown: grassetto, link, elenchi…).
- `title` / `description` sono titolo e SEO della pagina «Chi sono».

Se modifichi il YAML a mano: la barra verticale `|` dopo `about_author_long:` non va toccata; ogni riga del testo resta indentata; lascia una **riga vuota** (indentata) tra paragrafi. Non lasciare **spazi alla fine** di una riga.

Per aggiornare inglese o francese, usa le schede lingua nel CMS oppure i blocchi `en:` / `fr:` nello stesso file.

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
substack: simonacella
imdb: nm7677685
```

| Campo | Cosa scrivere |
|-------|----------------|
| `author` | Il tuo nome, così come deve apparire sul sito |
| `author-pic` | Percorso della foto profilo, es. `assets/img/nome-file.jpeg` — carica prima la foto in `assets/img/` (nome file senza spazi) |
| `email` | Il tuo indirizzo email |
| `website` | Il link completo al sito |
| `linkedin`, `instagram`, `facebook`, `substack` | Solo il tuo nome utente/handle, **non** il link intero (guarda gli esempi sopra) |
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

### Se il sito non si aggiorna dopo una modifica

La pubblicazione si interrompe se qualcosa nel contenuto non va (per esempio `lang:` sbagliato, immagine mancante, file tradotto con un nome diverso). In quel caso:

1. Apri la scheda **Actions** sul repository GitHub.
2. Apri l’esecuzione **rossa** più recente.
3. Leggi il riquadro **build summary**: elenca il file, il problema e cosa fare.

Correggi quanto indicato, salva e riprova. Finché la spunta non torna verde, il sito pubblico resta com’era.
