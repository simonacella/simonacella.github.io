# frozen_string_literal: true

# Author-facing content checks. All-or-nothing: collect every Block issue, write
# contenuto-errori.md, then abort the build. CI copies that file into the Actions
# Job Summary. No warn tier — if it is not worth failing publish, do not check it.
#
# Scans _posts/ on disk (so polyglot per-language builds still see the full triad).
# Runs once per Ruby process, after lang_slug (:high).

require "date"
require "yaml"

module Jekyll
  module ContentLint
    ERRORS_FILE = "contenuto-errori.md"
    LANG_SUFFIX = /\.(en|fr)\z/i
    POST_BASENAME = /\A(\d{4}-\d{2}-\d{2})-(.+?)(?:\.(en|fr))?\z/i
    YOUTUBE_TAG = /\{%\s*youtube\s+["']([^"']+)["']\s*%\}/i
    YOUTUBE_ID = /\A[A-Za-z0-9_-]{11}\z/
    INLINE_IMG = /!\[[^\]]*\]\(([^)]+)\)/
    CONTACT_KEYS = %w[linkedin github facebook instagram substack imdb].freeze

    module_function

    def run!(site)
      return if @ran

      @ran = true
      issues = []

      posts = load_posts(site)
      check_posts(site, posts, issues)
      check_pairing_and_tags(posts, issues)
      check_asset_filenames(site, issues)
      check_site_config(site, issues)

      return if issues.empty?

      body = format_report(issues)
      path = File.join(site.source, ERRORS_FILE)
      File.write(path, body, encoding: "UTF-8")
      Jekyll.logger.error "Contenuto:", "la pubblicazione è stata interrotta. Vedi #{ERRORS_FILE}"
      issues.each do |issue|
        Jekyll.logger.error "Contenuto:", "#{issue[:file]} — #{issue[:problem]}"
      end
      Jekyll.logger.abort_with "Contenuto:", "correggi gli errori elencati e riprova."
    end

    def load_posts(site)
      dir = File.join(site.source, "_posts")
      return [] unless Dir.exist?(dir)

      Dir.children(dir).sort.filter_map do |name|
        next unless name.end_with?(".md")

        path = File.join(dir, name)
        rel = File.join("_posts", name)
        basename = name.sub(/\.md\z/, "")
        parsed = parse_post(path)
        next unless parsed

        data, body = parsed
        date_s, stem, file_lang = parse_basename(basename)
        {
          name: name,
          rel: rel,
          path: path,
          basename: basename,
          date: date_s,
          stem: stem,
          file_lang: file_lang || "it",
          data: data,
          body: body
        }
      end
    end

    def parse_post(path)
      raw = File.read(path, encoding: "UTF-8")
      return [{}, raw] unless raw.start_with?("---")

      parts = raw.split(/^---\s*$/, 3)
      return [{}, raw] if parts.size < 3

      data = YAML.safe_load(parts[1], permitted_classes: [Date, Time], aliases: true) || {}
      [data, parts[2].to_s]
    rescue Psych::SyntaxError => e
      # Front-matter YAML errors are also caught by Jekyll; record a clear message.
      [{ "__yaml_error__" => e.message }, ""]
    end

    def parse_basename(basename)
      if (m = basename.match(POST_BASENAME))
        [m[1], m[2], m[3]&.downcase]
      else
        [nil, basename.sub(LANG_SUFFIX, ""), basename[LANG_SUFFIX, 1]&.downcase]
      end
    end

    def check_posts(site, posts, issues)
      posts.each do |post|
        rel = post[:rel]
        data = post[:data]

        if data["__yaml_error__"]
          add(issues, rel, "YAML del blocco in alto non valido (#{data['__yaml_error__']})",
              "Controlla le --- , le virgolette e i due punti in description.")
          next
        end

        if post[:name].include?(" ")
          add(issues, rel, "il nome del file contiene spazi",
              "Rinomina il file usando i trattini (-) al posto degli spazi.")
        end

        lang = data["lang"].to_s.strip
        expected = post[:file_lang]
        if lang.empty?
          add(issues, rel, "manca lang:",
              "Nel blocco in alto metti lang: #{expected}")
        elsif lang != expected
          add(issues, rel, "lang: è \"#{lang}\" ma il file richiede \"#{expected}\"",
              "Nel blocco in alto metti lang: #{expected}")
        end

        desc = data["description"]
        if desc.nil? || desc.to_s.strip.empty?
          add(issues, rel, "manca description (o è vuota)",
              "Aggiungi description: \"…\" tra virgolette, 1–2 frasi di riassunto.")
        end

        tags = data["tags"]
        unless tags.nil? || tags.is_a?(Array)
          add(issues, rel, "tags: non è un elenco tra parentesi quadre",
              "Usa la forma tags: [Regista, Paese, Cinema]")
        end

        flat_pub = data.key?("publisher") || data.key?("publication_link")
        nested = !data["republication"].nil?

        if flat_pub && nested
          add(issues, rel, "non mescolare publisher a livello radice e republication:",
              "Usa solo il blocco republication:, oppure solo le due righe piatte (non entrambi).")
        elsif nested
          rep = data["republication"]
          unless rep.is_a?(Hash)
            add(issues, rel, "republication: deve essere un blocco (non una stringa)",
                "Usa la forma:\nrepublication:\n  publisher: Nigrizia\n  publication_link: https://…")
          else
            pub_s = rep["publisher"].nil? ? "" : rep["publisher"].to_s.strip
            link_s = rep["publication_link"].nil? ? "" : rep["publication_link"].to_s.strip
            if pub_s.empty? || link_s.empty?
              add(issues, rel, "republication: serve sia publisher sia publication_link",
                  "Compila tutte e due le sottorighe, oppure cancella tutto il blocco republication.")
            end
          end
        elsif flat_pub
          pub_s = data["publisher"].nil? ? "" : data["publisher"].to_s.strip
          link_s = data["publication_link"].nil? ? "" : data["publication_link"].to_s.strip
          if pub_s.empty? || link_s.empty?
            add(issues, rel, "publisher e publication_link devono essere entrambi presenti o entrambi assenti",
                "Compila tutte e due le righe, oppure cancellale entrambe. (Il CMS scrive il blocco republication:.)")
          end
        end

        if data.key?("permalink")
          add(issues, rel, "non usare permalink: negli articoli",
              "Cancella la riga permalink: — l’indirizzo viene dal nome del file.")
        end

        if data.key?("slug") && !data["slug"].to_s.strip.empty?
          expected_slug = post[:stem]
          actual = data["slug"].to_s.strip
          if actual != expected_slug
            add(issues, rel,
                "slug: \"#{actual}\" non coincide col nome del file (atteso \"#{expected_slug}\")",
                "Di solito non serve slug:. Se c’è, deve essere uguale al nome senza data e senza .en/.fr. Oppure cancella la riga.")
          end
        end

        if data.key?("date")
          begin
            Date.parse(data["date"].to_s)
          rescue ArgumentError, TypeError
            add(issues, rel, "date: non è una data valida",
                "Usa il formato 2025-08-20 (data di pubblicazione sul sito).")
          end
        end

        check_cover(site, post, issues)
        check_inline_images(site, post, issues)
        check_youtube_tags(post, issues)
        check_lang_suffixed_slug(post, issues)
      end
    end

    def check_cover(site, post, issues)
      rel = post[:rel]
      img = post[:data]["img"]
      return if img.nil?

      img_s = img.to_s.strip
      if img_s.empty?
        add(issues, rel, "img: è vuoto",
            "Metti il percorso tipo /assets/img/posts/nome-immagine.jpg")
        return
      end

      # CMS writes /assets/img/posts/…; legacy posts/… still accepted.
      if img_s.start_with?("/assets/img/")
        full = File.join(site.source, img_s.delete_prefix("/"))
      elsif img_s.start_with?("posts/")
        full = File.join(site.source, "assets", "img", img_s)
      else
        add(issues, rel, "img: ha un formato sbagliato (\"#{img_s}\")",
            "Usa /assets/img/posts/nome-file.jpg (o il vecchio posts/nome-file.jpg).")
        return
      end

      return if File.file?(full)

      add(issues, rel, "immagine di copertina non trovata (img: #{img_s})",
          "Controlla il nome del file in assets/img/posts/ (maiuscole/minuscole comprese).")
    end

    def check_inline_images(site, post, issues)
      rel = post[:rel]
      post[:body].to_s.scan(INLINE_IMG) do |match|
        src = match[0].to_s.strip
        next if src.start_with?("http://", "https://", "//", "data:")

        if src.start_with?("assets/") || src.match?(%r{\Aposts/}) || !src.start_with?("/")
          add(issues, rel, "immagine nel testo con percorso sbagliato (#{src})",
              "Nel testo usa /assets/img/posts/nome.jpg (barra iniziale, percorso completo).")
          next
        end

        next unless src.start_with?("/assets/img/")

        full = File.join(site.source, src.delete_prefix("/"))
        next if File.file?(full)

        add(issues, rel, "immagine nel testo non trovata (#{src})",
            "Controlla il nome del file sotto assets/img/.")
      end
    end

    def check_youtube_tags(post, issues)
      post[:body].to_s.scan(YOUTUBE_TAG) do |match|
        url = match[0].to_s.strip
        next if youtube_id?(url)

        add(issues, post[:rel], "indirizzo YouTube non valido in {% youtube %}: #{url.inspect}",
            "Usa un link youtu.be/… o youtube.com/watch?v=… (copia da un articolo recente).")
      end
    end

    def youtube_id?(url)
      return true if url.match?(YOUTUBE_ID)
      return true if url.match?(%r{youtu\.be/([A-Za-z0-9_-]{11})})
      return true if url.match?(%r{(?:v=|/embed/|/v/|/shorts/)([A-Za-z0-9_-]{11})})

      false
    end

    def check_lang_suffixed_slug(post, issues)
      # After lang_slug, Jekyll slug should be the stem without .en/.fr.
      # If the basename pattern is wrong (e.g. Touki-Bouki-en.md), stem still
      # contains a language marker and pairing breaks.
      stem = post[:stem].to_s
      return unless stem.match?(LANG_SUFFIX) || stem.match?(/-(en|fr)\z/i)

      add(issues, post[:rel],
          "il nome del file non usa il suffisso lingua nel posto giusto (#{post[:name]})",
          "Usa Nome-Articolo.en.md / Nome-Articolo.fr.md (punto prima di en/fr), non -en alla fine.")
    end

    def check_pairing_and_tags(posts, issues)
      groups = posts.group_by { |p| [p[:date], p[:stem]] }
      # Near-duplicates: same date, stems that differ only by case or trailing -en
      by_date = posts.group_by { |p| p[:date] }
      by_date.each_value do |group|
        stems = group.map { |p| p[:stem] }.uniq
        next if stems.size <= 1

        # Flag when two stems look like the same article with a naming mistake
        stems.combination(2).each do |a, b|
          next unless similar_stems?(a, b)

          files = group.select { |p| [a, b].include?(p[:stem]) }.map { |p| p[:rel] }
          add(issues, files.first,
              "nomi file diversi per lo stesso articolo: #{stems.join(', ')}",
              "Le versioni IT/EN/FR devono avere la stessa data e lo stesso nome (solo .en / .fr cambia). File: #{files.join(', ')}")
        end
      end

      groups.each_value do |group|
        next if group.size < 2

        italian = group.find { |p| p[:file_lang] == "it" }
        next unless italian

        it_tags = Array(italian[:data]["tags"]).map(&:to_s)
        group.each do |post|
          next if post[:file_lang] == "it"

          other = Array(post[:data]["tags"]).map(&:to_s)
          next if other == it_tags

          add(issues, post[:rel],
              "i tags: non coincidono con la versione italiana",
              "Copia i tags: dall’articolo italiano e non tradurli.")
        end
      end
    end

    def similar_stems?(a, b)
      return true if a.downcase == b.downcase

      na = a.sub(/-(en|fr)\z/i, "")
      nb = b.sub(/-(en|fr)\z/i, "")
      na.downcase == nb.downcase && a != b
    end

    def check_asset_filenames(site, issues)
      root = File.join(site.source, "assets", "img")
      return unless Dir.exist?(root)

      Dir.glob(File.join(root, "**", "*")).each do |path|
        next unless File.file?(path)

        base = File.basename(path)
        next unless base.include?(" ")

        rel = path.delete_prefix(site.source + File::SEPARATOR)
        add(issues, rel, "il nome del file contiene spazi",
            "Rinomina il file con i trattini (-) e aggiorna i riferimenti negli articoli.")
      end
    end

    def check_site_config(site, issues)
      cfg_desc = site.config["description"].to_s.strip
      it = site.data.dig("site-text", "it") || {}
      data_desc = it["description"].to_s.strip
      if !cfg_desc.empty? && !data_desc.empty? && cfg_desc != data_desc
        add(issues, "_config.yml / _data/site-text.yml",
            "description italiana diversa tra _config.yml e site-text.yml (it)",
            "Tieni lo stesso testo in entrambi i file (blocco it: di site-text.yml).")
      end

      pic = site.config["author-pic"].to_s.strip
      unless pic.empty?
        full = File.join(site.source, pic)
        unless File.file?(full)
          add(issues, "_config.yml",
              "foto profilo non trovata (author-pic: #{pic})",
              "Controlla il percorso sotto assets/img/.")
        end
      end

      CONTACT_KEYS.each do |key|
        val = site.config[key].to_s.strip
        next if val.empty?
        next unless val.match?(%r{\Ahttps?://}i)

        add(issues, "_config.yml",
            "#{key}: contiene un URL completo",
            "Metti solo il nome utente/handle (guarda gli esempi nel README), non il link intero.")
      end
    end

    def add(issues, file, problem, fix)
      issues << { file: file, problem: problem, fix: fix }
    end

    def format_report(issues)
      lines = []
      lines << "## Pubblicazione interrotta"
      lines << ""
      lines << "Correggi quanto segue e riprova. Finché questi errori restano, il sito pubblico non si aggiorna."
      lines << ""
      issues.each_with_index do |issue, i|
        lines << "#{i + 1}) **File:** `#{issue[:file]}`"
        lines << "   - **Problema:** #{issue[:problem]}"
        lines << "   - **Cosa fare:** #{issue[:fix]}"
        lines << ""
      end
      lines.join("\n")
    end
  end
end

Jekyll::Hooks.register :site, :post_read, priority: :low do |site|
  Jekyll::ContentLint.run!(site)
end
