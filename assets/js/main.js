(function () {
  'use strict';

  // Localized strings injected by _includes/javascripts.html (with fallbacks).
  var i18n = window.i18n || {};
  var LABEL_OPEN_MENU = i18n.openMenu || 'Apri menu';
  var LABEL_CLOSE_MENU = i18n.closeMenu || 'Chiudi menu';

  var topButton = document.querySelector('.top');
  var flexContainer = document.querySelector('div.flex-container');
  var mainNav = document.getElementById('main-nav');
  var searchBox = document.querySelector('.search-box');
  var searchInput = document.getElementById('search-input');
  var menuOpen = document.querySelector('.menu-icon');
  var menuClose = document.querySelector('.menu-icon-close');
  var searchOpen = document.querySelector('.search-icon');
  var searchClose = document.querySelector('.search-icon-close');
  var prefersReducedMotion = window.matchMedia('(prefers-reduced-motion: reduce)').matches;
  var menuCloseDelay = prefersReducedMotion ? 0 : 600;
  var lastMenuTrigger = null;
  var lastSearchTrigger = null;

  function getFocusable(container) {
    if (!container) return [];
    return Array.prototype.slice.call(
      container.querySelectorAll(
        'a[href], button:not([disabled]), input:not([disabled]), textarea:not([disabled]), select:not([disabled]), [tabindex]:not([tabindex="-1"])'
      )
    ).filter(function (el) {
      return el.getClientRects().length > 0;
    });
  }

  // .search-box transitions out of visibility:hidden, and a hidden element
  // cannot take focus. The flip to visible only lands once the frame that
  // started the transition has been committed, so wait two frames.
  function focusWhenVisible(el) {
    if (!el) return;
    requestAnimationFrame(function () {
      requestAnimationFrame(function () {
        el.focus();
      });
    });
  }

  function trapFocus(e, container) {
    if (e.key !== 'Tab' || !container) return;
    var focusable = getFocusable(container);
    if (!focusable.length) return;
    var first = focusable[0];
    var last = focusable[focusable.length - 1];
    if (e.shiftKey && document.activeElement === first) {
      e.preventDefault();
      last.focus();
    } else if (!e.shiftKey && document.activeElement === last) {
      e.preventDefault();
      first.focus();
    }
  }

  function setNavOpen(isOpen) {
    if (!mainNav) return;
    mainNav.setAttribute('aria-hidden', isOpen ? 'false' : 'true');
    if ('inert' in mainNav) {
      mainNav.inert = !isOpen;
    }
  }

  function hideLayer() {
    if (!flexContainer || !menuOpen) return;
    flexContainer.classList.remove('opaque');
    flexContainer.classList.add('transparent');
    menuOpen.setAttribute('aria-expanded', 'false');
    menuOpen.setAttribute('aria-label', LABEL_OPEN_MENU);
    setTimeout(function () {
      flexContainer.classList.remove('active');
      setNavOpen(false);
      if (lastMenuTrigger) {
        lastMenuTrigger.focus();
        lastMenuTrigger = null;
      } else {
        menuOpen.focus();
      }
    }, menuCloseDelay);
  }

  function openMenu(trigger) {
    if (!flexContainer || !menuOpen) return;
    lastMenuTrigger = trigger || menuOpen;
    flexContainer.classList.add('active');
    menuOpen.setAttribute('aria-expanded', 'true');
    menuOpen.setAttribute('aria-label', LABEL_CLOSE_MENU);
    setNavOpen(true);
    setTimeout(function () {
      flexContainer.classList.remove('transparent');
      flexContainer.classList.add('opaque');
      if (menuClose) menuClose.focus();
    }, prefersReducedMotion ? 0 : 10);
  }

  setNavOpen(false);

  if (topButton) {
    topButton.addEventListener('click', function () {
      window.scrollTo({
        top: 0,
        behavior: prefersReducedMotion ? 'auto' : 'smooth'
      });
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
        openMenu(el);
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
    searchBox.setAttribute('aria-hidden', 'true');
    searchOpen.setAttribute('aria-expanded', 'false');
    if (lastSearchTrigger) {
      lastSearchTrigger.focus();
      lastSearchTrigger = null;
    } else {
      searchOpen.focus();
    }
  }

  function openSearch(trigger) {
    if (!searchBox || !searchOpen) return;
    lastSearchTrigger = trigger || searchOpen;
    searchBox.classList.add('search-active');
    searchBox.setAttribute('aria-hidden', 'false');
    searchOpen.setAttribute('aria-expanded', 'true');
    focusWhenVisible(searchInput);
  }

  window.addEventListener('keydown', function (e) {
    if (flexContainer && flexContainer.classList.contains('active')) {
      if (e.key === 'Escape') {
        hideLayer();
        return;
      }
      trapFocus(e, mainNav);
      return;
    }

    if (searchBox && searchBox.classList.contains('search-active')) {
      if (e.key === 'Escape') {
        closeSearch();
        return;
      }
      trapFocus(e, searchBox);
    }
  });

  if (searchOpen) {
    searchOpen.addEventListener('click', function (e) {
      e.preventDefault();
      if (!searchBox) return;
      if (searchBox.classList.contains('search-active')) {
        closeSearch();
      } else {
        openSearch(searchOpen);
      }
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
    var title = container.getAttribute('data-iframe-title') || 'Video YouTube';
    var iframe = document.createElement('iframe');
    iframe.title = title;
    iframe.src = 'https://www.youtube-nocookie.com/embed/' + id + '?autoplay=1';
    iframe.setAttribute(
      'allow',
      'accelerometer; autoplay; clipboard-write; encrypted-media; gyroscope; picture-in-picture; web-share'
    );
    iframe.setAttribute('allowfullscreen', '');
    iframe.setAttribute('loading', 'lazy');
    container.replaceChildren(iframe);
  });
})();
