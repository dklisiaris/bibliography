$(document).ready ->
  container = $('.book-container')  
  container.masonry
    gutter: 12        
    itemSelector: '.book-cover'
    isAnimated: true,
    animationOptions:
      duration: 700,
      easing: 'linear',
      queue: false
