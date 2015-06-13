$(document).ready ->
  window.onload = masonry_init

$(window).bind 'page:change', ->
  masonry_init()
  return 

masonry_init = ->
  container = $('.book-container')  
  container.masonry
    gutter: 12        
    itemSelector: '.book-cover'
    isAnimated: true,
    animationOptions:
      duration: 700,
      easing: 'linear',
      queue: false
