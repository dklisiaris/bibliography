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

  disconnect() {
    if (this.typeahead) destroyAutocomplete(this.typeahead)
    this.typeahead = null
  }
}
