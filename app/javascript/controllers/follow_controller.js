import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  static targets = ["icon", "label"]

  static values = {
    url: String,
    following: Boolean,
    followLabel: String,
    followingLabel: String,
    unfollowLabel: String,
  }

  connect() {
    this.previewing = false
    this.render()
  }

  toggle(event) {
    event.preventDefault()
    this.previewing = false

    const token = document.querySelector('meta[name="csrf-token"]')?.content

    fetch(this.urlValue, {
      method: "POST",
      headers: {
        "X-CSRF-Token": token,
        Accept: "application/json",
      },
      credentials: "same-origin",
    })
      .then((response) => {
        if (!response.ok) throw new Error("Follow request failed")
        return response.json()
      })
      .then((data) => {
        this.followingValue = data.followed
        this.render()
      })
      .catch(() => {})
  }

  previewUnfollow() {
    if (!this.followingValue) return

    this.previewing = true
    this.element.classList.remove("btn-success")
    this.element.classList.add("btn-danger")
    this.setIcon("fa-user-times")
    this.setLabel(this.unfollowLabelValue)
  }

  resetPreview() {
    if (!this.previewing) return

    this.previewing = false
    this.render()
  }

  render() {
    this.element.classList.remove("btn-outline-secondary", "btn-success", "btn-danger")

    if (this.followingValue) {
      this.element.classList.add("btn-success")
      this.setIcon("fa-users")
      this.setLabel(this.followingLabelValue)
    } else {
      this.element.classList.add("btn-outline-secondary")
      this.setIcon("fa-user-plus")
      this.setLabel(this.followLabelValue)
    }
  }

  setIcon(className) {
    const icon = this.hasIconTarget ? this.iconTarget : this.element.querySelector("i")
    if (icon) icon.className = `fa ${className}`
  }

  setLabel(text) {
    const label = this.hasLabelTarget ? this.labelTarget : this.element.querySelector("span")
    if (label) label.textContent = ` ${text}`
  }
}
