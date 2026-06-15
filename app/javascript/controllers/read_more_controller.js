import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  static values = {
    collapsedHeight: { type: Number, default: 80 },
    heightMargin: { type: Number, default: 16 },
    moreLabel: String,
    lessLabel: String,
    compact: { type: Boolean, default: false },
    speed: { type: Number, default: 500 },
  }

  connect() {
    this.expanded = false
    this.fullHeight = this.element.scrollHeight

    if (this.fullHeight <= this.collapsedHeightValue + this.heightMarginValue) return

    this.element.classList.add("read-more-content")
    this.element.style.transition = `max-height ${this.speedValue}ms ease`
    this.element.style.overflow = "hidden"
    this.element.style.maxHeight = `${this.collapsedHeightValue}px`

    this.toggleLink = document.createElement("a")
    this.toggleLink.href = "#"
    this.toggleLink.className = this.compactValue
      ? "read-more-toggle read-more-toggle--compact"
      : "read-more-toggle"
    this.toggleLink.textContent = this.moreLabelValue
    this.toggleLink.addEventListener("click", this.toggle)
    this.element.after(this.toggleLink)
  }

  disconnect() {
    this.toggleLink?.removeEventListener("click", this.toggle)
    this.toggleLink?.remove()
  }

  toggle = (event) => {
    event.preventDefault()
    this.expanded = !this.expanded

    if (this.expanded) {
      this.element.style.maxHeight = `${this.fullHeight}px`
      this.toggleLink.textContent = this.lessLabelValue
      window.setTimeout(() => {
        if (!this.expanded) return
        this.element.style.maxHeight = "none"
        this.element.style.overflow = "visible"
      }, this.speedValue)
    } else {
      this.element.style.overflow = "hidden"
      this.element.style.maxHeight = `${this.fullHeight}px`
      void this.element.offsetHeight
      this.element.style.maxHeight = `${this.collapsedHeightValue}px`
      this.toggleLink.textContent = this.moreLabelValue
    }
  }
}
