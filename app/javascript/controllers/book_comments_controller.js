import { Controller } from "@hotwired/stimulus"
import {
  apiAuthHeaders,
  buildBookCommentHtml,
  formatCommentBody,
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

  postComment(event) {
    event.preventDefault()
    const button = event.target.closest(".post-comment")
    const form = button?.closest(".book-comment-form__form")
    if (!form) return

    const commentArea = form.querySelector(".comment-area")
    const comment = commentArea?.value?.trim()
    if (!comment) return

    const parentId = form.querySelector("input[name='parent_id']")?.value
    const normalHtml = button.innerHTML

    commentArea.value = ""
    setButtonLoading(button, true, normalHtml)

    fetch(`/api/v1/books/${this.bookIdValue}/comments/`, {
      method: "POST",
      headers: apiAuthHeaders(this.emailValue, this.tokenValue),
      body: JSON.stringify({
        comment: {
          body: formatCommentBody(comment),
          parent_id: parentId,
        },
      }),
    })
      .then((response) => {
        if (!response.ok) throw new Error("Comment post failed")
        return response.json()
      })
      .then((data) => {
        const html = buildBookCommentHtml({
          id: data.comment.id,
          bookId: this.bookIdValue,
          userId: data.comment.user.id,
          avatar: data.comment.user.image,
          userName: data.comment.user.name,
          body: data.comment.body,
          size: 32,
        })

        document.getElementById(`comment-form-block-${parentId}`)?.insertAdjacentHTML("beforebegin", html)
      })
      .finally(() => setButtonLoading(button, false, normalHtml))
  }

  toggleReplyForm(event) {
    event.preventDefault()
    const button = event.target.closest(".write-comment-btn")
    const form = button?.previousElementSibling
    if (!form?.classList.contains("book-comment-form__form")) return

    form.style.display = ""
    button.style.display = "none"

    document.querySelectorAll(".book-comment-form__form").forEach((el) => {
      if (el !== form) el.style.display = "none"
    })
    document.querySelectorAll(".write-comment-btn").forEach((el) => {
      if (el !== button) el.style.display = ""
    })
  }

  deleteComment(event) {
    event.preventDefault()
    const button = event.target.closest(".delete-comment")
    const commentEl = button?.closest(".book-comment")
    if (!commentEl) return

    const commentId = commentEl.id.replace("comment-", "")
    const bookId = commentEl.dataset.bookId || this.bookIdValue

    fetch(`/api/v1/books/${bookId}/comments/${commentId}`, {
      method: "DELETE",
      headers: apiAuthHeaders(this.emailValue, this.tokenValue),
    })
      .then((response) => {
        if (!response.ok) throw new Error("Comment delete failed")
        commentEl.remove()
      })
      .catch(() => {})
  }
}
