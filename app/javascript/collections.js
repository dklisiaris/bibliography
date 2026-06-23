import { updateTooltip } from "./tooltip"
import { hideModal } from "./modal"
import { showToast } from "./toast"

function csrfToken() {
  return document.querySelector('meta[name="csrf-token"]')?.content
}

export function updateCollectionsButton(bookId, hasCollections, labels) {
  const wrapper = document.querySelector(`.collections-btn-${bookId}`)
  if (!wrapper) return

  const button = wrapper.querySelector(".collections-btn")
  const tooltipWrapper = wrapper.querySelector(".tooltip-wrapper")
  if (!button) return

  button.classList.remove("btn-primary", "btn-success")
  button.classList.add(hasCollections ? "btn-success" : "btn-primary")

  const icon = button.querySelector("i")
  if (icon) {
    icon.classList.remove("fa-plus", "fa-check")
    icon.classList.add(hasCollections ? "fa-check" : "fa-plus")
  }

  const span = button.querySelector("span")
  if (span) {
    span.textContent = ` ${hasCollections ? labels.added : labels.add}`
  }

  if (tooltipWrapper) {
    const title = hasCollections ? labels.editTooltip : labels.addTooltip
    updateTooltip(tooltipWrapper, title)
  }
}

export async function loadBookCollections(bookId) {
  const response = await fetch(`/books/${bookId}/collections`, {
    headers: { Accept: "application/json" },
    credentials: "same-origin",
  })

  if (!response.ok) throw new Error("Failed to load collections")

  return response.json()
}

export async function saveBookCollections(bookId, toAdd, toRemove) {
  const formData = new FormData()
  toAdd.forEach((id) => formData.append("to_add[]", id))
  toRemove.forEach((id) => formData.append("to_remove[]", id))

  const response = await fetch(`/books/${bookId}/collections`, {
    method: "POST",
    headers: {
      "X-CSRF-Token": csrfToken(),
      Accept: "application/json",
    },
    credentials: "same-origin",
    body: formData,
  })

  if (!response.ok) throw new Error("Failed to save collections")

  return response.json()
}

export function applyCollectionCheckboxes(modalElement, collections) {
  modalElement.querySelectorAll('input[type="checkbox"]').forEach((checkbox) => {
    checkbox.checked = false
  })

  const checkedIds = []

  collections.forEach((collection) => {
    const checkbox = modalElement.querySelector(`#collection-${collection.id}`)
    if (checkbox) {
      checkbox.checked = true
      checkedIds.push(collection.id)
    }
  })

  return checkedIds
}

export function checkedCollectionIds(modalElement) {
  const ids = []

  modalElement
    .querySelectorAll(".collections-checkboxes input[type='checkbox']:checked")
    .forEach((checkbox) => {
      const id = parseInt(checkbox.id.split("-").pop(), 10)
      if (!Number.isNaN(id)) ids.push(id)
    })

  return ids
}

export function collectionDiff(wasChecked, isChecked) {
  const toAdd = isChecked.filter((id) => !wasChecked.includes(id))
  const toRemove = wasChecked.filter((id) => !isChecked.includes(id))

  return { toAdd, toRemove }
}

export function hideCollectionsModal(modalElement) {
  hideModal(modalElement)
}

export function notifyCollectionsSaved(message) {
  showToast(message, "success")
}

export function notifyCollectionsError(message) {
  showToast(message, "error")
}
