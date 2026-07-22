$(function () {
  'use strict';

  /* -------- Scroll to top button ------- */
  $(".top").click(function() {
    $("html, body")
      .stop()
      .animate({ scrollTop: 0 }, "slow", "swing");
  });

  $(window).scroll(function() {
    if ($(this).scrollTop() > $(window).height()) {
      $(".top").addClass("is-active");
    } else {
      $(".top").removeClass("is-active");
    }
  });

  // Cache variables for increased performance on devices with slow CPUs.
  var flexContainer = $('div.flex-container')
  var searchBox = $('.search-box')
  var searchClose = $('.search-icon-close')
  var searchInput = $('#search-input')
  var menuOpen = $('.menu-icon')
  var searchOpen = $('.search-icon')
  var waiting;

  // Menu button
  $('.menu-icon, .menu-icon-close').click(function (e) {
    e.preventDefault()
    e.stopPropagation()
    if (flexContainer.hasClass('active')){
      hideLayer();
    } else {
      flexContainer.addClass('active')
      menuOpen.attr('aria-expanded', 'true')
      setTimeout(function () {
        flexContainer.removeClass('transparent').addClass('opaque');
      }, 10);
    }
  })

  // Click to close
  flexContainer.click(function (e) {
    if (flexContainer.hasClass('active') && e.target.tagName !== 'A') {
      if (e.target.classList.contains('night')) {
        clearTimeout(waiting);
        waiting = setTimeout(function() {
          hideLayer();
        }, 1000);
      } else {
        hideLayer();
      }
    }
  })

  function hideLayer () {
    flexContainer.removeClass('opaque')
    flexContainer.addClass('transparent');
    menuOpen.attr('aria-expanded', 'false')
    setTimeout(function(){
      flexContainer.removeClass('active');
    }, 600)
  }

  // Press Escape key to close menu
  $(window).keydown(function (e) {
    if (e.key === 'Escape') {
      if (flexContainer.hasClass('active')) {
        hideLayer();
      } else if (searchBox.hasClass('search-active')) {
        searchBox.removeClass('search-active');
        searchOpen.attr('aria-expanded', 'false')
      }
    }
  })

  // Search button
  $('.search-icon').click(function (e) {
    e.preventDefault()
    if($('.search-form.inline').length == 0){
        searchBox.toggleClass('search-active')
        searchOpen.attr('aria-expanded', searchBox.hasClass('search-active') ? 'true' : 'false')
    }
    searchInput.focus()
    if (searchBox.hasClass('search-active')) {
      searchClose.off('click').on('click', function (e) {
        e.preventDefault()
        searchBox.removeClass('search-active')
        searchOpen.attr('aria-expanded', 'false')
      })
    }
  })

  // YouTube: load iframe only after click (avoids third-party cookies on page load)
  $(document).on('click', '.youtube-embed .youtube-play', function () {
    var container = $(this).closest('.youtube-embed')
    var id = container.data('youtube-id')
    if (!id) return
    container.html(
      '<iframe title="Video YouTube" src="https://www.youtube-nocookie.com/embed/' +
        id +
        '?autoplay=1" allow="accelerometer; autoplay; clipboard-write; encrypted-media; gyroscope; picture-in-picture; web-share" allowfullscreen loading="lazy"></iframe>'
    )
  })
});
