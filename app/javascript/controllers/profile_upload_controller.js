import { Controller } from "@hotwired/stimulus"
import Dropzone from "dropzone"
import { hideModal } from "../modal"

Dropzone.autoDiscover = false

function csrfToken() {
  return document.querySelector('meta[name="csrf-token"]')?.content
}

function parseResponse(response) {
  if (typeof response === "string") {
    try {
      return JSON.parse(response)
    } catch {
      return {}
    }
  }
  return response || {}
}

export default class extends Controller {
  static values = {
    modalId: String,
  }

  connect() {
    this.dropzone = new Dropzone(this.element, {
      paramName: "file",
      maxFilesize: 2,
      maxFiles: 1,
      headers: csrfToken() ? { "X-CSRF-Token": csrfToken() } : {},
      init: () => {
        this.element.classList.add("dz-started")
      },
    })

    this.dropzone.on("success", (file, response) => {
      this.handleSuccess(file, parseResponse(response))
    })
  }

  disconnect() {
    this.dropzone?.destroy()
    this.dropzone = null
  }

  handleSuccess(file, response) {
    if (this.hasModalIdValue) {
      hideModal(document.getElementById(this.modalIdValue))
    }

    const coverUrl = response.cover?.url
    if (coverUrl) {
      document.querySelector(".profile-show__cover .cover")?.setAttribute("src", coverUrl)
    }

    const avatarUrl = response.avatar?.url
    if (avatarUrl) {
      document.getElementById("profileAvatar")?.setAttribute("src", avatarUrl)
      document.getElementById("topHeaderAvatar")?.setAttribute("src", avatarUrl)
    }

    this.dropzone.removeFile(file)
  }
}
