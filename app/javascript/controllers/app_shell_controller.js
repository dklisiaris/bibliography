import { Controller } from "@hotwired/stimulus"
import { Offcanvas } from "bootstrap"

const STORAGE_KEY = "bibliography-sidebar-mini"

export default class extends Controller {
  connect() {
    this.syncDesktopSidebarState()
    this.bindMobileNavDismissal()
    this.bindNavbarGlass()
    this.resizePageContent()
    this.boundResize = () => this.resizePageContent()
    window.addEventListener("resize", this.boundResize)
    window.addEventListener("orientationchange", this.boundResize)
  }

  disconnect() {
    if (this.boundResize) {
      window.removeEventListener("resize", this.boundResize)
      window.removeEventListener("orientationchange", this.boundResize)
    }
    if (this.boundScroll) {
      window.removeEventListener("scroll", this.boundScroll)
    }
  }

  bindNavbarGlass() {
    this.header = this.element.querySelector(".app-shell__navbar")
    if (!this.header) return

    this.boundScroll = () => {
      this.header.classList.toggle("navbar-glass", window.scrollY > 50)
    }
    window.addEventListener("scroll", this.boundScroll, { passive: true })
    this.boundScroll()
  }

  resizePageContent() {
    const pageContent = document.getElementById("page-content")
    if (!pageContent) return

    const header = this.element.querySelector(".app-shell__navbar")
    const headerH = header ? header.offsetHeight : 0
    pageContent.style.minHeight = `${window.innerHeight - headerH}px`
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
