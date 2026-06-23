const VARIANTS = {
  book: {
    displayKey: "title",
    tokenFields: ["title"],
  },
  author: {
    displayKey: "name",
    tokenFields: ["lastname"],
  },
  simple: {
    displayKey: "name",
    tokenFields: ["name"],
  },
  multisearch: {
    displayKey: "title",
    tokenFields: ["title", "name", "lastname"],
  },
}

function jquery() {
  return window.jQuery
}

function bloodhound() {
  return window.Bloodhound
}

function mapBookSuggestions(suggestions) {
  return suggestions.map((suggestion) => ({
    title: suggestion.title,
    image: suggestion.image,
    writer:
      suggestion.writers?.length > 0 ? suggestion.writers[0].fullname : "",
    url: suggestion.site_url,
  }))
}

function mapAuthorSuggestions(suggestions) {
  return suggestions.map((suggestion) => ({
    name: [suggestion.lastname, suggestion.firstname].join(", "),
    image: suggestion.image,
    url: suggestion.site_url,
  }))
}

function mapSimpleSuggestions(suggestions) {
  return suggestions.map((suggestion) => ({
    name: suggestion.name,
    url: suggestion.site_url,
  }))
}

function mapMultisearchSuggestions(suggestions, labels) {
  const results = suggestions.results || {}

  const books = (results.books || []).map((suggestion) => ({
    title: suggestion.title,
    image: suggestion.image || "/no_cover.jpg",
    secondary_title:
      suggestion.writers?.length > 0 ? suggestion.writers[0].fullname : "",
    url: suggestion.site_url,
  }))

  const authors = (results.authors || []).map((suggestion) => ({
    title: [suggestion.lastname, suggestion.firstname].join(", "),
    secondary_title: "",
    image: suggestion.image,
    url: suggestion.site_url,
  }))

  const publishers = (results.publishers || []).map((suggestion) => ({
    title: suggestion.name,
    secondary_title: labels.publisherLabel,
    image: "",
    url: suggestion.site_url,
  }))

  const categories = (results.categories || []).map((suggestion) => ({
    title: suggestion.name,
    secondary_title: labels.categoryLabel,
    image: "",
    url: suggestion.site_url,
  }))

  const series = (results.series || []).map((suggestion) => ({
    title: suggestion.name,
    secondary_title: labels.seriesLabel,
    image: "",
    url: suggestion.site_url,
  }))

  return books.concat(authors, publishers, categories, series)
}

function buildFilter(variant, labels) {
  switch (variant) {
    case "book":
      return mapBookSuggestions
    case "author":
      return mapAuthorSuggestions
    case "simple":
      return mapSimpleSuggestions
    case "multisearch":
      return (suggestions) => mapMultisearchSuggestions(suggestions, labels)
    default:
      return mapSimpleSuggestions
  }
}

function buildEmptyTemplate(nothingFound) {
  return [
    '<div class="tt-result"><div class="tt-result-details"><span>',
    nothingFound,
    "</span></div></div>",
  ].join("")
}

function bookSuggestionTemplate(data) {
  const image = data.image || "/no_cover.jpg"

  return (
    '<div class="tt-result">' +
    '<div class="tt-result__cover">' +
    `<img src="${image}" alt="" loading="lazy">` +
    "</div>" +
    '<div class="tt-result__body">' +
    `<div class="tt-result__title">${data.title}</div>` +
    `<div class="tt-result__meta">${data.writer || ""}</div>` +
    "</div>" +
    "</div>"
  )
}

function authorSuggestionTemplate(data) {
  return (
    '<div class="tt-result">' +
    '<div class="tt-result__cover">' +
    `<img src="${data.image}" alt="" loading="lazy">` +
    "</div>" +
    '<div class="tt-result__body">' +
    `<div class="tt-result__title">${data.name}</div>` +
    "</div>" +
    "</div>"
  )
}

function simpleSuggestionTemplate(data) {
  return (
    '<div class="tt-result">' +
    '<div class="tt-result__body">' +
    `<div class="tt-result__title">${data.name}</div>` +
    "</div>" +
    "</div>"
  )
}

function multisearchSuggestionTemplate(data) {
  const coverElement = data.image
    ? '<div class="tt-result__cover">' +
      `<img src="${data.image}" alt="" loading="lazy">` +
      "</div>"
    : ""

  return (
    '<div class="tt-result">' +
    coverElement +
    '<div class="tt-result__body">' +
    `<div class="tt-result__title">${data.title}</div>` +
    `<div class="tt-result__meta">${data.secondary_title || ""}</div>` +
    "</div>" +
    "</div>"
  )
}

function attachSearchBarMenu($input) {
  const $group = $input.closest(".search-bar__group")
  const $menu = $input.closest(".twitter-typeahead").find(".tt-menu")
  if (!$group.length || !$menu.length) return

  $menu.css({
    position: "absolute",
    top: $group.outerHeight() + 6,
    left: 0,
    right: 0,
    width: "auto",
  })
}

function buildSuggestionTemplate(variant) {
  switch (variant) {
    case "book":
      return bookSuggestionTemplate
    case "author":
      return authorSuggestionTemplate
    case "multisearch":
      return multisearchSuggestionTemplate
    default:
      return simpleSuggestionTemplate
  }
}

function querySorter(input, queryFieldName) {
  return (a, b) => {
    const query = (
      document.querySelector(`input[name="${queryFieldName}"]`)?.value ||
      input.value ||
      ""
    ).toLowerCase()
    const indexA = (a.value || "").toLowerCase().indexOf(query)
    const indexB = (b.value || "").toLowerCase().indexOf(query)

    if (indexA < indexB) return -1
    if (indexA > indexB) return 1
    return 0
  }
}

export function initAutocomplete(input, options) {
  const $ = jquery()
  const Bloodhound = bloodhound()

  if (!$ || !Bloodhound || !$.fn.typeahead) return null

  const variant = options.variant || "simple"
  const config = VARIANTS[variant] || VARIANTS.simple
  const displayKey = options.displayKey || config.displayKey
  const tokenFields = options.tokenFields || config.tokenFields
  const queryFieldName = options.queryFieldName || "q"
  const labels = {
    publisherLabel: options.publisherLabel || "",
    categoryLabel: options.categoryLabel || "",
    seriesLabel: options.seriesLabel || "",
  }

  const engine = new Bloodhound({
    datumTokenizer: Bloodhound.tokenizers.obj.whitespace(tokenFields),
    queryTokenizer: Bloodhound.tokenizers.whitespace,
    sorter: querySorter(input, queryFieldName),
    remote: {
      url: options.url,
      wildcard: "%QUERY",
      rateLimitWait: 500,
      filter: buildFilter(variant, labels),
    },
  })

  engine.initialize()

  const $input = $(input)

  $input.typeahead(
    {
      hint: true,
      highlight: true,
      minLength: 1,
    },
    {
      displayKey,
      limit: Infinity,
      source: engine.ttAdapter(),
      templates: {
        empty: buildEmptyTemplate(options.nothingFound),
        suggestion: buildSuggestionTemplate(variant),
      },
    }
  )

  $input.on("typeahead:selected", (_event, datum) => {
    window.location.href = datum.url
  })

  $input.on(
    "typeahead:render typeahead:open typeahead:asyncreceive",
    () => {
      attachSearchBarMenu($input)
    }
  )

  $input.on("typeahead:asyncrequest", () => {
    input.classList.add("loading")
  })

  $input.on("typeahead:asynccancel typeahead:asyncreceive", () => {
    input.classList.remove("loading")
  })

  attachSearchBarMenu($input)

  return { engine, $input }
}

export function destroyAutocomplete(typeaheadInstance) {
  const $input = typeaheadInstance?.$input
  if (!$input) return

  $input.off(
    "typeahead:selected typeahead:asyncrequest typeahead:asynccancel typeahead:asyncreceive"
  )
  $input.typeahead("destroy")
}
