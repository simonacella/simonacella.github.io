(function () {
  'use strict';

  // Config injected by _includes/javascripts.html: the language-scoped index
  // URL and localized status strings.
  var config = window.searchConfig || {};
  var input = document.getElementById('search-input');
  var results = document.getElementById('results-container');
  if (!input || !results || !config.json) return;

  var FIELDS = ['title', 'tags', 'description', 'content'];
  var LIMIT = 10;
  var posts = null;
  var requested = false;

  // Fold accents so "hyenes" matches "Hyènes" (and the same for à/é/ù in IT/FR).
  function fold(value) {
    return String(value || '')
      .normalize('NFD')
      .replace(/[\u0300-\u036f]/g, '')
      .toLowerCase();
  }

  function showStatus(message) {
    var item = document.createElement('li');
    item.className = 'results-status';
    item.textContent = message;
    results.replaceChildren(item);
  }

  function matches(post, query) {
    return FIELDS.some(function (field) {
      return fold(post[field]).indexOf(query) > -1;
    });
  }

  // textContent escapes by construction, so post fields need no sanitizing.
  function toListItem(post) {
    var link = document.createElement('a');
    link.href = post.url;
    link.title = post.description || '';
    link.textContent = post.title;

    var blurb = document.createElement('p');
    blurb.textContent = post.description || '';

    var item = document.createElement('li');
    item.append(link, blurb);
    return item;
  }

  function render() {
    var query = fold(input.value.trim());
    if (!query) return results.replaceChildren();
    loadIndex();
    // Still fetching: render() runs again once the index arrives.
    if (!posts) return;

    var found = [];
    for (var i = 0; i < posts.length && found.length < LIMIT; i++) {
      if (matches(posts[i], query)) found.push(toListItem(posts[i]));
    }
    if (!found.length) return showStatus(config.noResultsText);
    results.replaceChildren.apply(results, found);
  }

  // The index carries the full text of every article, so it is fetched only
  // once the reader reaches for search — ordinary page views never pay for it.
  function loadIndex() {
    if (requested) return;
    requested = true;
    fetch(config.json).then(function (response) {
      if (!response.ok) throw new Error('HTTP ' + response.status);
      return response.json();
    }).then(function (json) {
      posts = json;
      render();
    }).catch(function (error) {
      // Tell the reader instead of leaving a dead-looking input.
      showStatus(config.errorText);
      if (window.console && window.console.error) {
        window.console.error('search --- failed to load ' + config.json + ': ' + error.message);
      }
    });
  }

  // Opening the box and focusing the field only warm the index, so the fetch
  // overlaps with typing; render() loads it too and is the guarantee. Both are
  // idempotent, and neither runs on an ordinary page view.
  var trigger = document.querySelector('.search-icon');
  if (trigger) trigger.addEventListener('click', loadIndex, { once: true });
  input.addEventListener('focus', loadIndex, { once: true });

  // `input` covers typing, paste, autofill and IME composition, and does not
  // fire for navigation keys — so rendered results are left alone by arrows.
  input.addEventListener('input', render);
})();
