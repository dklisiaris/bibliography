import { Controller } from "@hotwired/stimulus"
import { showModal } from "../modal"

export default class extends Controller {
  open(event) {
    event.preventDefault()
    const modal = document.getElementById(event.params.id)
    if (modal) showModal(modal)
  }
}
