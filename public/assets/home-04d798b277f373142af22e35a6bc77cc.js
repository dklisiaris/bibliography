(function(){$(".home").ready(function(){var e;return e=new Bloodhound({datumTokenizer:function(e){return Bloodhound.tokenizers.whitespace(e.value)},queryTokenizer:Bloodhound.tokenizers.whitespace,limit:10,remote:{url:"/autocomplete?query=%QUERY",filter:function(e){return $.map(e,function(e){return{value:e}})}}}),e.initialize(),$("#remote .typeahead").typeahead(null,{displayKey:"value",source:e.ttAdapter()})})}).call(this);