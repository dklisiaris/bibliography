# Place all the behaviors and hooks related to the matching controller here.
# All this logic will automatically be available in application.js.
# You can use CoffeeScript in this file: http://coffeescript.org/
$ ->
  # Instantiate the Bloodhound suggestion engine
  suggestions = new Bloodhound(
    datumTokenizer: (datum) ->
      Bloodhound.tokenizers.whitespace datum.value

    queryTokenizer: Bloodhound.tokenizers.whitespace
    limit: 10
    remote:
      url: "/autocomplete?query=%QUERY"
      filter: (suggestions) ->
        
        # Map the remote source JSON array to a JavaScript object array
        $.map suggestions, (suggestion) ->
          value: suggestion    
  )

  # Initialize the Bloodhound suggestion engine
  suggestions.initialize()

  # Instantiate the Typeahead UI
  $("#remote .typeahead").typeahead null,
    displayKey: "value"
    source: suggestions.ttAdapter()

   