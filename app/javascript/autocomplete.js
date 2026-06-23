const VARIANTS = {
  book: { displayKey: "title", tokenFields: ["title"] },
  author: { displayKey: "name", tokenFields: ["lastname"] },
  simple: { displayKey: "name", tokenFields: ["name"] },
  multisearch: { displayKey: "title", tokenFields: ["title", "name", "lastname"] },
}

const DEBOUNCE_MS = 300

function escapeHtml(value) {
  return String(value ?? "")
    .replace(/&/g, "&amp;")
    .replace(/</g, "&lt;")
    .replace(/>/g, "&gt;")
    .replace(/"/g, "&quot;")
}

function mapBookSuggestions(suggestions) {
  return suggestions.map((suggestion) => ({
    title: suggestion.title,
    image: suggestion.image,
    writer: suggestion.writers?.length > 0 ? suggestion.writers[0].fullname : "",
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

function mapMultisearchSuggestions(payload, labels) {
  const results = payload.results || {}

  const books = (results.books || []).map((suggestion) => ({
    title: suggestion.title,
    image: suggestion.image || "/no_cover.jpg",
    secondary_title: suggestion.writers?.length > 0 ? suggestion.writers[0].fullname : "",
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
    case "multisearch":
      return (payload) => mapMultisearchSuggestions(payload, labels)
    default:
      return mapSimpleSuggestions
  }
}

function displayText(item, displayKey) {
  return item[displayKey] || item.title || item.name || ""
}

function sortByQuery(items, query, displayKey) {
  const normalized = query.trim().toLowerCase()
  if (!normalized) return items

  return [...items].sort((left, right) => {
    const indexLeft = displayText(left, displayKey).toLowerCase().indexOf(normalized)
    const indexRight = displayText(right, displayKey).toLowerCase().indexOf(normalized)

    if (indexLeft < indexRight) return -1
    if (indexLeft > indexRight) return 1
    return 0
  })
}

function bookSuggestionElement(data) {
  const image = data.image || "/no_cover.jpg"
  const element = document.createElement("div")
  element.className = "tt-suggestion"
  element.dataset.url = data.url
  element.innerHTML =
    '<div class="tt-result">' +
    '<div class="tt-result__cover">' +
    `<img src="${escapeHtml(image)}" alt="" loading="lazy">` +
    "</div>" +
    '<div class="tt-result__body">' +
    `<div class="tt-result__title">${escapeHtml(data.title)}</div>` +
    `<div class="tt-result__meta">${escapeHtml(data.writer || "")}</div>` +
    "</div>" +
    "</div>"
  return element
}

function authorSuggestionElement(data) {
  const element = document.createElement("div")
  element.className = "tt-suggestion"
  element.dataset.url = data.url
  element.innerHTML =
    '<div class="tt-result">' +
    '<div class="tt-result__cover">' +
    `<img src="${escapeHtml(data.image)}" alt="" loading="lazy">` +
    "</div>" +
    '<div class="tt-result__body">' +
    `<div class="tt-result__title">${escapeHtml(data.name)}</div>` +
    "</div>" +
    "</div>"
  return element
}

function simpleSuggestionElement(data) {
  const element = document.createElement("div")
  element.className = "tt-suggestion"
  element.dataset.url = data.url
  element.innerHTML =
    '<div class="tt-result">' +
    '<div class="tt-result__body">' +
    `<div class="tt-result__title">${escapeHtml(data.name)}</div>` +
    "</div>" +
    "</div>"
  return element
}

function multisearchSuggestionElement(data) {
  const coverElement = data.image
    ? '<div class="tt-result__cover">' +
      `<img src="${escapeHtml(data.image)}" alt="" loading="lazy">` +
      "</div>"
    : ""

  const element = document.createElement("div")
  element.className = "tt-suggestion"
  element.dataset.url = data.url
  element.innerHTML =
    '<div class="tt-result">' +
    coverElement +
    '<div class="tt-result__body">' +
    `<div class="tt-result__title">${escapeHtml(data.title)}</div>` +
    `<div class="tt-result__meta">${escapeHtml(data.secondary_title || "")}</div>` +
    "</div>" +
    "</div>"
  return element
}

function buildSuggestionElement(variant) {
  switch (variant) {
    case "book":
      return bookSuggestionElement
    case "author":
      return authorSuggestionElement
    case "multisearch":
      return multisearchSuggestionElement
    default:
      return simpleSuggestionElement
  }
}

class Autocomplete {
  constructor(input, options) {
    this.input = input
    this.container = options.container || input.closest(".search-bar__group") || input.parentElement
    this.variant = options.variant || "simple"
    this.config = VARIANTS[this.variant] || VARIANTS.simple
    this.displayKey = options.displayKey || this.config.displayKey
    this.queryFieldName = options.queryFieldName || "q"
    this.urlTemplate = options.url
    this.nothingFound = options.nothingFound || "Nothing found"
    this.labels = {
      publisherLabel: options.publisherLabel || "",
      categoryLabel: options.categoryLabel || "",
      seriesLabel: options.seriesLabel || "",
    }
    this.filterResults = buildFilter(this.variant, this.labels)
    this.renderSuggestion = buildSuggestionElement(this.variant)
    this.minLength = 1
    this.debounceTimer = null
    this.abortController = null
    this.activeIndex = -1
    this.items = []
    this.isOpen = false

    this.onInput = this.onInput.bind(this)
    this.onKeyDown = this.onKeyDown.bind(this)
    this.onDocumentClick = this.onDocumentClick.bind(this)
    this.onMenuMouseDown = this.onMenuMouseDown.bind(this)

    this.menu = document.createElement("div")
    this.menu.className = "tt-menu"
    this.menu.hidden = true
    this.menu.setAttribute("role", "listbox")

    this.dataset = document.createElement("div")
    this.dataset.className = "tt-dataset"
    this.menu.appendChild(this.dataset)

    this.container.appendChild(this.menu)

    this.input.addEventListener("input", this.onInput)
    this.input.addEventListener("keydown", this.onKeyDown)
    this.menu.addEventListener("mousedown", this.onMenuMouseDown)
    document.addEventListener("click", this.onDocumentClick)
  }

  destroy() {
    window.clearTimeout(this.debounceTimer)
    this.abortController?.abort()
    this.input.removeEventListener("input", this.onInput)
    this.input.removeEventListener("keydown", this.onKeyDown)
    this.menu.removeEventListener("mousedown", this.onMenuMouseDown)
    document.removeEventListener("click", this.onDocumentClick)
    this.menu.remove()
  }

  onMenuMouseDown(event) {
    event.preventDefault()
  }

  onDocumentClick(event) {
    if (!this.container.contains(event.target)) this.close()
  }

  onInput() {
    window.clearTimeout(this.debounceTimer)
    this.debounceTimer = window.setTimeout(() => this.fetchSuggestions(), DEBOUNCE_MS)
  }

  onKeyDown(event) {
    if (!this.isOpen && !["ArrowDown", "ArrowUp"].includes(event.key)) return

    switch (event.key) {
      case "ArrowDown":
        event.preventDefault()
        this.moveActive(1)
        break
      case "ArrowUp":
        event.preventDefault()
        this.moveActive(-1)
        break
      case "Enter":
        if (this.isOpen && this.activeIndex >= 0) {
          event.preventDefault()
          this.selectIndex(this.activeIndex)
        }
        break
      case "Escape":
        this.close()
        break
      default:
        break
    }
  }

  moveActive(delta) {
    if (!this.items.length) return

    if (!this.isOpen) {
      this.open()
      this.activeIndex = 0
    } else {
      this.activeIndex = Math.max(0, Math.min(this.items.length - 1, this.activeIndex + delta))
    }

    this.syncActiveSuggestion()
  }

  syncActiveSuggestion() {
    this.dataset.querySelectorAll(".tt-suggestion").forEach((element, index) => {
      element.classList.toggle("tt-cursor", index === this.activeIndex)
    })
  }

  selectIndex(index) {
    const item = this.items[index]
    if (item?.url) window.location.href = item.url
  }

  queryValue() {
    const namedInput = document.querySelector(`input[name="${this.queryFieldName}"]`)
    return (namedInput?.value || this.input.value || "").trim()
  }

  buildUrl(query) {
    return this.urlTemplate.replace("%QUERY", encodeURIComponent(query))
  }

  setLoading(isLoading) {
    this.input.classList.toggle("loading", isLoading)
  }

  async fetchSuggestions() {
    const query = this.queryValue()
    if (query.length < this.minLength) {
      this.close()
      return
    }

    this.abortController?.abort()
    this.abortController = new AbortController()
    this.setLoading(true)

    try {
      const response = await fetch(this.buildUrl(query), {
        signal: this.abortController.signal,
        headers: { Accept: "application/json" },
        credentials: "same-origin",
      })

      if (!response.ok) throw new Error("Autocomplete request failed")

      const payload = await response.json()
      const mapped = this.filterResults(payload)
      this.items = sortByQuery(mapped, query, this.displayKey)
      this.renderResults()
    } catch (error) {
      if (error.name !== "AbortError") this.close()
    } finally {
      this.setLoading(false)
    }
  }

  renderResults() {
    this.dataset.replaceChildren()
    this.activeIndex = -1

    if (!this.items.length) {
      const empty = document.createElement("div")
      empty.className = "tt-empty-message"
      empty.textContent = this.nothingFound
      this.dataset.appendChild(empty)
      this.open()
      return
    }

    this.items.forEach((item, index) => {
      const element = this.renderSuggestion(item)
      element.addEventListener("click", () => this.selectIndex(index))
      this.dataset.appendChild(element)
    })

    this.open()
  }

  open() {
    this.isOpen = true
    this.menu.hidden = false
  }

  close() {
    this.isOpen = false
    this.activeIndex = -1
    this.menu.hidden = true
    this.dataset.replaceChildren()
    this.items = []
  }
}

export function initAutocomplete(input, options) {
  if (!input || !options?.url) return null
  return new Autocomplete(input, options)
}

export function destroyAutocomplete(instance) {
  instance?.destroy()
}
