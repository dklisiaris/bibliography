$(document).ready ->
  container = $('.book-container')  
  container.masonry
    gutter: 15        
    itemSelector: '.book-cover'