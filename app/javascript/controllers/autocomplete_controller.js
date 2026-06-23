import { Controller } from "@hotwired/stimulus"
import { destroyAutocomplete, initAutocomplete } from "../autocomplete"

export default class extends Controller {
  static targets = ["input"]

  static values = {
    url: String,
    variant: { type: String, default: "simple" },
    nothingFound: String,
    publisherLabel: String,
    categoryLabel: String,
    seriesLabel: String,
  }

  connect() {
    this.initAttempts = 0
    this.initTypeahead()
  }

  disconnect() {
    window.clearTimeout(this.retryTimer)
    if (this.typeahead) destroyAutocomplete(this.typeahead)
    this.typeahead = null
  }

  initTypeahead() {
    if (!window.jQuery?.fn?.typeahead || !window.Bloodhound) {
      if (this.initAttempts < 20) {
        this.initAttempts += 1
        this.retryTimer = window.setTimeout(() => this.initTypeahead(), 50)
      }
      return
    }

    this.typeahead = initAutocomplete(this.inputTarget, {
      url: this.urlValue,
      variant: this.variantValue,
      nothingFound: this.nothingFoundValue,
      publisherLabel: this.hasPublisherLabelValue
        ? this.publisherLabelValue
        : "",
      categoryLabel: this.hasCategoryLabelValue ? this.categoryLabelValue : "",
      seriesLabel: this.hasSeriesLabelValue ? this.seriesLabelValue : "",
    })
  }
}
