import { Controller } from "@hotwired/stimulus"
import { showToast } from "../toast"

export default class extends Controller {
  static values = {
    message: String,
    type: { type: String, default: "success" },
  }

  connect() {
    showToast(this.messageValue, this.typeValue)
    this.element.remove()
  }
}
