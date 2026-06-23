import { Controller } from "@hotwired/stimulus"
import { hideBs3Modal, showBs3Modal } from "../bs3_modal"

export default class extends Controller {
  open(event) {
    event.preventDefault()
    const modal = document.getElementById(event.params.id)
    if (modal) showBs3Modal(modal)
  }

  close(event) {
    event.preventDefault()
    const modal = event.currentTarget.closest(".modal")
    if (modal) hideBs3Modal(modal)
  }
}
