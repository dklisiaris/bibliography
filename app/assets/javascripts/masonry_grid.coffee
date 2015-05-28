$(document).ready ->
  window.onload = masonry_init

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
