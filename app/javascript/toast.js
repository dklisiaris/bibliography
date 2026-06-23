const TOAST_TIMEOUT_MS = 5000
const CONTAINER_ID = "flash-toast-container"

const TYPE_CLASSES = {
  success: "alert-success",
  error: "alert-danger",
  warning: "alert-warning",
  info: "alert-info",
}

function container() {
  let element = document.getElementById(CONTAINER_ID)
  if (element) return element

  element = document.createElement("div")
  element.id = CONTAINER_ID
  element.className = "flash-toast-container"
  element.setAttribute("aria-live", "polite")
  element.setAttribute("aria-atomic", "true")
  document.body.appendChild(element)
  return element
}

function dismissToast(toast) {
  toast.classList.add("flash-toast--dismissing")
  window.setTimeout(() => toast.remove(), 450)
}

export function showToast(message, type = "success") {
  if (!message) return

  const toast = document.createElement("div")
  toast.className = `alert ${TYPE_CLASSES[type] || TYPE_CLASSES.info} alert-dismissible flash-toast`
  toast.setAttribute("role", "alert")

  const close = document.createElement("button")
  close.type = "button"
  close.className = "btn-close"
  close.setAttribute("data-bs-dismiss", "alert")
  close.setAttribute("aria-label", "Close")
  close.addEventListener("click", () => dismissToast(toast))

  const body = document.createElement("span")
  body.textContent = message

  toast.append(close, body)
  container().appendChild(toast)

  window.setTimeout(() => {
    if (toast.isConnected) dismissToast(toast)
  }, TOAST_TIMEOUT_MS)
}
