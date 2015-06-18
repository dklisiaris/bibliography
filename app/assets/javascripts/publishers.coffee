# Place all the behaviors and hooks related to the matching controller here.
# All this logic will automatically be available in application.js.
# You can use CoffeeScript in this file: http://coffeescript.org/

$(".publishers").ready ->
  # Instantiate the Bloodhound suggestion engine
  engine = new Bloodhound(
    datumTokenizer: Bloodhound.tokenizers.obj.whitespace('name'),
    queryTokenizer: Bloodhound.tokenizers.whitespace
    sorter: (a, b) ->
      q = $("input:text[name=q]").val().toLowerCase()
      index_a = a.value.toLowerCase().indexOf(q)
      index_b = b.value.toLowerCase().indexOf(q)
      if index_a < index_b        
        -1
      else if index_a > index_b
        1
      else
        0    
    limit: 10
    remote:
      url: "/publishers?autocomplete=1&q=%QUERY"
      wildcard: "%QUERY"
      filter: (suggestions) ->
        
        # Map the remote source JSON array to a JavaScript object array
        $.map suggestions, (suggestion) ->
          name: suggestion['name']
          url: suggestion['url']
  )

  # Initialize the Bloodhound suggestion engine
  engine.initialize()  

  # Instantiate the Typeahead UI
  $("#remote .typeahead").typeahead(
    hint: true
    highlight: true
    minLength: 1
  ,  
    displayKey: "name"
    source: engine.ttAdapter()
  ).bind 'typeahead:selected', (obj,datum) ->    
    window.location.href = datum.url.replace("api/v1/", "")
    return

