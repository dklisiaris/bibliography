@notify = (message, type) ->
  n = noty(  
    layout: 'topRight',
    theme: 'relax',
    type: type,  
    text: message
    animation:
      open: 'animated bounceInRight'
      close: 'animated bounceOutRight'
      easing: 'swing'
      speed: 500
    timeout: 5000)  