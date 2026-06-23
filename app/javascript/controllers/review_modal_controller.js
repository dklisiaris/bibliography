import { Controller } from "@hotwired/stimulus"
import { hideBs3Modal, showBs3Modal } from "../bs3_modal"

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
    this.open()
  }

  open(event) {
    event?.preventDefault()
    showBs3Modal(this.element)
  }

  close(event) {
    event?.preventDefault()
    hideBs3Modal(this.element)
  }
}
