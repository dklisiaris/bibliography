import { Controller } from "@hotwired/stimulus"
import { hideModal } from "../modal"
import {
  apiAuthHeaders,
  buildBookCommentHtml,
} from "../book_comments"

function setButtonLoading(button, loading, normalHtml) {
  if (loading) {
    button.dataset.normalHtml = button.innerHTML
    button.innerHTML = `<i class="fa fa-circle-o-notch fa-spin fa-fw"></i>${normalHtml}`
    button.disabled = true
  } else {
    button.innerHTML = button.dataset.normalHtml || normalHtml
    button.disabled = false
  }
}

export default class extends Controller {
  static values = {
    bookId: Number,
    email: String,
    token: String,
  }

  post(event) {
    event.preventDefault()

    const form = this.element.querySelector("#reviewForm")
    const commentInput = form?.querySelector("input[name='comment[body]']")
    const comment = commentInput?.value?.trim()
    if (!comment) return

    const button = event.target.closest("#postReviewBtn")
    const normalHtml = button.innerHTML
    setButtonLoading(button, true, normalHtml)

    fetch(`/api/v1/books/${this.bookIdValue}/comments/`, {
      method: "POST",
      headers: apiAuthHeaders(this.emailValue, this.tokenValue),
      body: JSON.stringify({ comment: { body: comment } }),
    })
      .then((response) => {
        if (!response.ok) throw new Error("Review post failed")
        return response.json()
      })
      .then((data) => {
        hideModal(this.element)

        const html = buildBookCommentHtml({
          id: data.comment.id,
          bookId: this.bookIdValue,
          userId: data.comment.user.id,
          avatar: data.comment.user.image,
          userName: data.comment.user.name,
          body: data.comment.body,
          size: 40,
        })

        document.getElementById("reviews-list")?.insertAdjacentHTML("afterbegin", html)

        const editor = document.querySelector("trix-editor")?.editor
        if (editor) {
          editor.setSelectedRange([0, comment.length])
          editor.deleteInDirection("backward")
        }

        document.getElementById("reviewBtn")?.remove()
      })
      .finally(() => setButtonLoading(button, false, normalHtml))
  }
}
