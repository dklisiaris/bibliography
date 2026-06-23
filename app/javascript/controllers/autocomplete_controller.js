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
    this.instance = initAutocomplete(this.inputTarget, {
      container: this.element,
      url: this.urlValue,
      variant: this.variantValue,
      nothingFound: this.nothingFoundValue,
      publisherLabel: this.hasPublisherLabelValue ? this.publisherLabelValue : "",
      categoryLabel: this.hasCategoryLabelValue ? this.categoryLabelValue : "",
      seriesLabel: this.hasSeriesLabelValue ? this.seriesLabelValue : "",
    })
  }

  disconnect() {
    destroyAutocomplete(this.instance)
    this.instance = null
  }
}
