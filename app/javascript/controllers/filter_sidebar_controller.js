import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  static targets = ["panel"]

  toggle(event) {
    event.preventDefault()
    this.panelTarget.classList.toggle("open")
  }
}
