(function () {
  'use strict';

  var topButton = document.querySelector('.top');
  var flexContainer = document.querySelector('div.flex-container');
  var searchBox = document.querySelector('.search-box');
  var searchInput = document.getElementById('search-input');
  var menuOpen = document.querySelector('.menu-icon');
  var searchOpen = document.querySelector('.search-icon');
  var searchClose = document.querySelector('.search-icon-close');

  function hideLayer() {
    if (!flexContainer || !menuOpen) return;
    flexContainer.classList.remove('opaque');
    flexContainer.classList.add('transparent');
    menuOpen.setAttribute('aria-expanded', 'false');
    setTimeout(function () {
      flexContainer.classList.remove('active');
    }, 600);
  }

  if (topButton) {
    topButton.addEventListener('click', function () {
      window.scrollTo({ top: 0, behavior: 'smooth' });
    });

    window.addEventListener('scroll', function () {
      if (window.pageYOffset > window.innerHeight) {
        topButton.classList.add('is-active');
      } else {
        topButton.classList.remove('is-active');
      }
    }, { passive: true });
  }

  document.querySelectorAll('.menu-icon, .menu-icon-close').forEach(function (el) {
    el.addEventListener('click', function (e) {
      e.preventDefault();
      e.stopPropagation();
      if (!flexContainer || !menuOpen) return;
      if (flexContainer.classList.contains('active')) {
        hideLayer();
      } else {
        flexContainer.classList.add('active');
        menuOpen.setAttribute('aria-expanded', 'true');
        setTimeout(function () {
          flexContainer.classList.remove('transparent');
          flexContainer.classList.add('opaque');
        }, 10);
      }
    });
  });

  if (flexContainer) {
    flexContainer.addEventListener('click', function (e) {
      if (flexContainer.classList.contains('active') && e.target.tagName !== 'A') {
        hideLayer();
      }
    });
  }

  function closeSearch() {
    if (!searchBox || !searchOpen) return;
    searchBox.classList.remove('search-active');
    searchOpen.setAttribute('aria-expanded', 'false');
  }

  window.addEventListener('keydown', function (e) {
    if (e.key !== 'Escape') return;
    if (flexContainer && flexContainer.classList.contains('active')) {
      hideLayer();
    } else if (searchBox && searchBox.classList.contains('search-active')) {
      closeSearch();
    }
  });

  if (searchOpen) {
    searchOpen.addEventListener('click', function (e) {
      e.preventDefault();
      if (!searchBox) return;
      searchBox.classList.toggle('search-active');
      searchOpen.setAttribute(
        'aria-expanded',
        searchBox.classList.contains('search-active') ? 'true' : 'false'
      );
      if (searchInput) searchInput.focus();
    });
  }

  if (searchClose) {
    searchClose.addEventListener('click', function (e) {
      e.preventDefault();
      closeSearch();
    });
  }

  if (searchBox) {
    searchBox.addEventListener('click', function (e) {
      if (e.target === searchBox) closeSearch();
    });
  }

  document.addEventListener('click', function (e) {
    var playButton = e.target.closest('.youtube-embed .youtube-play');
    if (!playButton) return;
    var container = playButton.closest('.youtube-embed');
    if (!container) return;
    var id = container.getAttribute('data-youtube-id');
    if (!id) return;
    container.innerHTML =
      '<iframe title="Video YouTube" src="https://www.youtube-nocookie.com/embed/' +
      id +
      '?autoplay=1" allow="accelerometer; autoplay; clipboard-write; encrypted-media; gyroscope; picture-in-picture; web-share" allowfullscreen loading="lazy"></iframe>';
  });
})();
