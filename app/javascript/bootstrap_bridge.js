import {
  Tooltip,
  Dropdown,
  Modal,
  Tab
} from "bootstrap"

function initBootstrapComponents(root = document) {
  root.querySelectorAll('[data-bs-toggle="tooltip"]').forEach((el) => {
    Tooltip.getOrCreateInstance(el, { container: "body", animation: false })
  })

  root.querySelectorAll('[data-bs-toggle="dropdown"]').forEach((el) => {
    Dropdown.getOrCreateInstance(el)
  })

  root.querySelectorAll(".modal").forEach((el) => {
    Modal.getOrCreateInstance(el)
  })

  root.querySelectorAll('[data-bs-toggle="tab"]').forEach((el) => {
    if (el.dataset.bsTabBound) return
    el.dataset.bsTabBound = "true"
    el.addEventListener("click", (event) => {
      event.preventDefault()
      Tab.getOrCreateInstance(el).show()
    })
  })
}

export function initBootstrapBridge() {
  initBootstrapComponents()
}

document.addEventListener("DOMContentLoaded", initBootstrapBridge)
document.addEventListener("turbo:load", initBootstrapBridge)
