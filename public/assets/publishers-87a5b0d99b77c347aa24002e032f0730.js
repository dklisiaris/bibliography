(function(){$(".publishers").ready(function(){var e;return e=new Bloodhound({datumTokenizer:function(e){return Bloodhound.tokenizers.whitespace(e.value)},queryTokenizer:Bloodhound.tokenizers.whitespace,sorter:function(e,t){var n,r,i;return i=$("input:text[name=query]").val().toLowerCase(),n=e.value.toLowerCase().indexOf(i),r=t.value.toLowerCase().indexOf(i),r>n?-1:n>r?1:0},limit:10,remote:{url:"publishers/search.json?query=%QUERY",filter:function(e){return $.map(e,function(e){return{value:e}})}}}),e.initialize(),$("#remote .typeahead").typeahead({hint:!0,highlight:!0,minLength:1},{displayKey:"value",source:e.ttAdapter()})})}).call(this);