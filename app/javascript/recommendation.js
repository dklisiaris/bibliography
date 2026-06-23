import { updateTooltip } from "./tooltip"

function csrfToken() {
  return document.querySelector('meta[name="csrf-token"]')?.content
}

const labelsByBookId = new Map()

export function registerRecommendationLabels(bookId, labels) {
  labelsByBookId.set(String(bookId), labels)
}

function labelsFor(bookId) {
  return labelsByBookId.get(String(bookId))
}

function updateCount(button, count) {
  const span = button.querySelector("span")
  if (span) span.textContent = ` ${count}`
}

function updateProgressBar(bookId, likes, dislikes) {
  const total = likes + dislikes
  const width = total > 0 ? (likes / total) * 100 : 0

  document.querySelectorAll(`.recommendations-bar-${bookId}`).forEach((bar) => {
    bar.setAttribute("aria-valuenow", likes)
    bar.setAttribute("aria-valuemax", total)
    bar.style.width = `${width}%`
  })
}

function applyLikeState(bookId, likes, dislikes, liked) {
  const labels = labelsFor(bookId)
  if (!labels) return

  document.querySelectorAll(`.btn-like-${bookId}`).forEach((button) => {
    button.classList.remove("btn-outline-secondary", "btn-success")
    button.classList.add(liked ? "btn-success" : "btn-outline-secondary")
    updateCount(button, likes)
    updateTooltip(
      button,
      liked ? labels.removeRecommendation : labels.recommend
    )
  })

  document.querySelectorAll(`.btn-dislike-${bookId}`).forEach((button) => {
    button.classList.remove("btn-danger")
    button.classList.add("btn-outline-secondary")
    updateCount(button, dislikes)
    updateTooltip(button, labels.notRecommend)
  })

  updateProgressBar(bookId, likes, dislikes)
}

function applyDislikeState(bookId, likes, dislikes, disliked) {
  const labels = labelsFor(bookId)
  if (!labels) return

  document.querySelectorAll(`.btn-dislike-${bookId}`).forEach((button) => {
    button.classList.remove("btn-outline-secondary", "btn-danger")
    button.classList.add(disliked ? "btn-danger" : "btn-outline-secondary")
    updateCount(button, dislikes)
    updateTooltip(
      button,
      disliked ? labels.removeRecommendation : labels.notRecommend
    )
  })

  document.querySelectorAll(`.btn-like-${bookId}`).forEach((button) => {
    button.classList.remove("btn-success")
    button.classList.add("btn-outline-secondary")
    updateCount(button, likes)
    updateTooltip(button, labels.recommend)
  })

  updateProgressBar(bookId, likes, dislikes)
}

export async function submitRecommendation(bookId, action, labels) {
  if (labels) registerRecommendationLabels(bookId, labels)

  const likeButton = document.querySelector(`.btn-like-${bookId}`)
  const dislikeButton = document.querySelector(`.btn-dislike-${bookId}`)
  const wasLiked = likeButton?.classList.contains("btn-success") ?? false
  const wasDisliked = dislikeButton?.classList.contains("btn-danger") ?? false

  const response = await fetch(`/books/${bookId}/${action}`, {
    method: "POST",
    headers: {
      "X-CSRF-Token": csrfToken(),
      Accept: "application/json",
    },
    credentials: "same-origin",
  })

  if (!response.ok) throw new Error("Recommendation request failed")

  const data = await response.json()

  if (action === "like") {
    applyLikeState(bookId, data.likes, data.dislikes, !wasLiked)
  } else {
    applyDislikeState(bookId, data.likes, data.dislikes, !wasDisliked)
  }

  return data
}
