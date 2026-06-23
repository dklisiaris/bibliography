import {
  Tooltip,
  Dropdown,
  Modal,
  Tab
} from "bootstrap"

function bridgeLegacyAttributes() {
  document.querySelectorAll("[data-toggle]").forEach((el) => {
    const toggle = el.getAttribute("data-toggle")
    if (toggle && !el.hasAttribute("data-bs-toggle")) {
      el.setAttribute("data-bs-toggle", toggle === "tabs" ? "tab" : toggle)
    }
    const target = el.getAttribute("data-target")
    if (target && !el.hasAttribute("data-bs-target")) {
      el.setAttribute("data-bs-target", target)
    }
  })

  document.querySelectorAll("[data-dismiss]").forEach((el) => {
    if (!el.hasAttribute("data-bs-dismiss")) {
      el.setAttribute("data-bs-dismiss", el.getAttribute("data-dismiss"))
    }
  })
}

function initBootstrapComponents(root = document) {
  bridgeLegacyAttributes()

  root.querySelectorAll('[data-bs-toggle="tooltip"], [data-toggle="tooltip"], .enable-tooltip').forEach((el) => {
    Tooltip.getOrCreateInstance(el, { container: "body", animation: false })
  })

  root.querySelectorAll('[data-bs-toggle="dropdown"], [data-toggle="dropdown"]').forEach((el) => {
    const menu = el.closest(".dropdown")?.querySelector(".dropdown-menu")
    if (menu?.classList.contains("dropdown-menu-right")) {
      menu.classList.add("dropdown-menu-end")
    }

    Dropdown.getOrCreateInstance(el)
  })

  root.querySelectorAll(".modal").forEach((el) => {
    if (el.id === "collectionsModal" || el.id === "reviewModal" || el.id === "avatarModal" || el.id === "coverModal") return
    Modal.getOrCreateInstance(el)
  })

  root.querySelectorAll('.nav-tabs a[href^="#"], [data-bs-toggle="tab"]').forEach((el) => {
    if (el.dataset.bsTabBound) return
    el.dataset.bsTabBound = "true"
    if (!el.hasAttribute("data-bs-toggle")) {
      el.setAttribute("data-bs-toggle", "tab")
    }
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
