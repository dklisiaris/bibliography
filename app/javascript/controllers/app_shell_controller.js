import { Controller } from "@hotwired/stimulus"
import { Offcanvas } from "bootstrap"

const STORAGE_KEY = "bibliography-sidebar-mini"

export default class extends Controller {
  connect() {
    this.syncDesktopSidebarState()
    this.bindMobileNavDismissal()
  }

  toggleDesktopSidebar(event) {
    event?.preventDefault()
    if (!this.isDesktop()) return

    this.element.classList.toggle("app-shell--sidebar-mini")
    localStorage.setItem(STORAGE_KEY, this.element.classList.contains("app-shell--sidebar-mini"))
  }

  closeMobileSidebar() {
    const offcanvasEl = document.getElementById("appSidebarOffcanvas")
    if (!offcanvasEl) return

    const instance = Offcanvas.getInstance(offcanvasEl) || Offcanvas.getOrCreateInstance(offcanvasEl)
    instance.hide()
  }

  syncDesktopSidebarState() {
    if (!this.isDesktop()) return

    const mini = localStorage.getItem(STORAGE_KEY) === "true"
    this.element.classList.toggle("app-shell--sidebar-mini", mini)
  }

  bindMobileNavDismissal() {
    const offcanvasEl = document.getElementById("appSidebarOffcanvas")
    if (!offcanvasEl) return

    offcanvasEl.querySelectorAll(".app-sidebar__link").forEach((link) => {
      link.addEventListener("click", () => this.closeMobileSidebar())
    })
  }

  isDesktop() {
    return window.matchMedia("(min-width: 992px)").matches
  }
}
