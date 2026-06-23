// Bootstrap 3 modal show/hide without jQuery (profile avatar/cover modals until migrated).

const BACKDROP_ATTR = "data-bs3-modal-backdrop"

function backdropFor(modalEl) {
  return document.querySelector(`[${BACKDROP_ATTR}="${modalEl.id}"]`)
}

export function showBs3Modal(modalEl) {
  if (!modalEl || modalEl.classList.contains("in")) return

  if (!backdropFor(modalEl)) {
    const backdrop = document.createElement("div")
    backdrop.className = "modal-backdrop fade in"
    backdrop.setAttribute(BACKDROP_ATTR, modalEl.id)
    document.body.appendChild(backdrop)
  }

  document.body.classList.add("modal-open")
  modalEl.style.display = "block"
  modalEl.setAttribute("aria-hidden", "false")
  modalEl.classList.add("in")
}

export function hideBs3Modal(modalEl) {
  if (!modalEl) return

  modalEl.style.display = "none"
  modalEl.classList.remove("in")
  modalEl.setAttribute("aria-hidden", "true")

  const backdrop = backdropFor(modalEl)
  if (backdrop) backdrop.remove()

  if (!document.querySelector(".modal.in")) {
    document.body.classList.remove("modal-open")
  }
}
