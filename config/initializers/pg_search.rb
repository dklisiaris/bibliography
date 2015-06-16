PgSearch.multisearch_options = {
  :using => {
    :tsearch => {:prefix => true, :tsvector_column => :tsearch_vector},
    :trigram => {:threshold => 0.15}
  }, 
  :ignoring => :accents
}