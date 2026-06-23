import { Controller } from "@hotwired/stimulus"
import { hideModal, showModal } from "../modal"

export default class extends Controller {
  connect() {
    this.handleDocumentClick = this.handleDocumentClick.bind(this)
    document.addEventListener("click", this.handleDocumentClick)
  }

  disconnect() {
    document.removeEventListener("click", this.handleDocumentClick)
  }

  handleDocumentClick(event) {
    const trigger = event.target.closest("#reviewBtn")
    if (!trigger) return

    event.preventDefault()
    showModal(this.element)
  }
}
