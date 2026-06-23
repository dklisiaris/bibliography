import { Modal } from "bootstrap"

export function getModal(modalEl) {
  if (!modalEl) return null
  return Modal.getOrCreateInstance(modalEl)
}

export function showModal(modalEl) {
  getModal(modalEl)?.show()
}

export function hideModal(modalEl) {
  getModal(modalEl)?.hide()
}
