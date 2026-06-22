import { updateTooltip } from "./tooltip"

function csrfToken() {
  return document.querySelector('meta[name="csrf-token"]')?.content
}

const labelsByKey = new Map()

export function registerFavouriteLabels(kind, recordId, labels) {
  labelsByKey.set(`${kind}-${recordId}`, labels)
}

function labelsFor(kind, recordId) {
  return labelsByKey.get(`${kind}-${recordId}`)
}

function setStarIcon(button, favourited) {
  const icon = button.querySelector("i")
  if (!icon) return

  icon.classList.remove("fa-star", "fa-star-o")
  icon.classList.add(favourited ? "fa-star" : "fa-star-o")
}

function applyFavouriteState(kind, recordId, favourited, inactiveClass) {
  const labels = labelsFor(kind, recordId)
  const selector = `.btn-favourite-${kind}-${recordId}`

  document.querySelectorAll(selector).forEach((button) => {
    button.classList.remove("btn-success", "btn-default", "btn-primary")
    button.classList.add(favourited ? "btn-success" : inactiveClass)
    setStarIcon(button, favourited)

    if (labels) {
      updateTooltip(
        button,
        favourited ? labels.favoured : labels.addToFavourites
      )
    }
  })
}

export async function submitFavourite({ url, kind, recordId, inactiveClass, labels }) {
  if (labels) registerFavouriteLabels(kind, recordId, labels)

  const response = await fetch(url, {
    method: "POST",
    headers: {
      "X-CSRF-Token": csrfToken(),
      Accept: "application/json",
    },
    credentials: "same-origin",
  })

  if (!response.ok) throw new Error("Favourite request failed")

  const data = await response.json()
  applyFavouriteState(kind, recordId, data.favourite, inactiveClass)

  return data
}
