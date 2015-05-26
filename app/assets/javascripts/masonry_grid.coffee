$(document).ready ->
  container = $('.book-container')  
  container.masonry
    gutter: 12        
    itemSelector: '.book-cover'