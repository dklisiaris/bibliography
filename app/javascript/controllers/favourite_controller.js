import { Controller } from "@hotwired/stimulus"
import { registerFavouriteLabels, submitFavourite } from "../favourite"

export default class extends Controller {
  static values = {
    url: String,
    recordId: Number,
    kind: String,
    inactiveClass: { type: String, default: "btn-default" },
    addLabel: String,
    favouredLabel: String,
  }

  connect() {
    registerFavouriteLabels(this.kindValue, this.recordIdValue, {
      addToFavourites: this.addLabelValue,
      favoured: this.favouredLabelValue,
    })
  }

  toggle(event) {
    event.preventDefault()
    submitFavourite({
      url: this.urlValue,
      kind: this.kindValue,
      recordId: this.recordIdValue,
      inactiveClass: this.inactiveClassValue,
    }).catch(() => {})
  }
}
