# Place all the behaviors and hooks related to the matching controller here.
# All this logic will automatically be available in application.js.
# You can use CoffeeScript in this file: http://coffeescript.org/

$(".publishers").ready ->
  # Instantiate the Bloodhound suggestion engine
  engine = new Bloodhound(
    datumTokenizer: (datum) ->
      Bloodhound.tokenizers.whitespace datum.value

    queryTokenizer: Bloodhound.tokenizers.whitespace
    sorter: (a, b) ->
      q = $("input:text[name=query]").val().toLowerCase()
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
      url: "publishers/search.json?query=%QUERY"
      filter: (suggestions) ->
        
        # Map the remote source JSON array to a JavaScript object array
        $.map suggestions, (suggestion) ->
          value: suggestion 
  )

  # Initialize the Bloodhound suggestion engine
  engine.initialize()

  query = $("input:text[name=query]").val()

  # engine.get myQuery, (suggestions) ->
  #   suggestions.each (suggestion) ->
  #     console.log suggestion
  #     return
  #   return 

  # orig_get = engine.get
  # engine.get = (query, cb) ->
  #   orig_get.apply engine, [
  #     query
  #     (suggestions) ->
  #       return cb(suggestions)  unless suggestions
  #       suggestions.forEach (s) ->
  #         s.exact_match = (if query.toLowerCase() is s.name.toLowerCase() then 1 else 0)
  #         return

  #       suggestions.sort (a, b) ->
  #         (if a.exact_match > b.exact_match then -1 else (if a.exact_match < b.exact_match then 1 else 0))

  #       cb suggestions
  #   ]   

  # Instantiate the Typeahead UI
  $("#remote .typeahead").typeahead
    hint: true
    highlight: true
    minLength: 1
  ,  
    displayKey: "value"
    source: engine.ttAdapter()
