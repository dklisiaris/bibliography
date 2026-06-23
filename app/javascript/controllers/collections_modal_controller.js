import { Controller } from "@hotwired/stimulus"
import { hideModal, showModal } from "../modal"
import {
  applyCollectionCheckboxes,
  checkedCollectionIds,
  collectionDiff,
  loadBookCollections,
  notifyCollectionsError,
  notifyCollectionsSaved,
  saveBookCollections,
  updateCollectionsButton,
} from "../collections"

export default class extends Controller {
  static targets = ["spinner", "checkboxes"]

  static values = {
    successMessage: String,
    errorMessage: String,
    addLabel: String,
    addedLabel: String,
    addTooltip: String,
    editTooltip: String,
  }

  connect() {
    this.wasChecked = []
    this.bookId = null
    this.handleDocumentClick = this.handleDocumentClick.bind(this)
    document.addEventListener("click", this.handleDocumentClick)
  }

  disconnect() {
    document.removeEventListener("click", this.handleDocumentClick)
  }

  handleDocumentClick(event) {
    const trigger = event.target.closest(".collections-btn[data-book-id]")
    if (!trigger) return

    event.preventDefault()
    this.openForBook(parseInt(trigger.dataset.bookId, 10))
  }

  openForBook(bookId) {
    if (Number.isNaN(bookId)) return

    this.bookId = bookId
    showModal(this.element)
    this.showLoading()

    loadBookCollections(bookId)
      .then((collections) => {
        this.wasChecked = applyCollectionCheckboxes(this.element, collections)
        this.showCheckboxes()
      })
      .catch(() => {
        this.showCheckboxes()
        notifyCollectionsError(this.errorMessageValue)
        hideModal(this.element)
      })
  }

  save(event) {
    event.preventDefault()

    if (!this.bookId) return

    const isChecked = checkedCollectionIds(this.element)
    const { toAdd, toRemove } = collectionDiff(this.wasChecked, isChecked)
    const labels = {
      add: this.addLabelValue,
      added: this.addedLabelValue,
      addTooltip: this.addTooltipValue,
      editTooltip: this.editTooltipValue,
    }

    saveBookCollections(this.bookId, toAdd, toRemove)
      .then(() => {
        updateCollectionsButton(this.bookId, isChecked.length > 0, labels)
        notifyCollectionsSaved(this.successMessageValue)
        hideModal(this.element)
      })
      .catch(() => {
        notifyCollectionsError(this.errorMessageValue)
        hideModal(this.element)
      })
  }

  showLoading() {
    if (this.hasSpinnerTarget) this.spinnerTarget.style.display = ""
    if (this.hasCheckboxesTarget) this.checkboxesTarget.style.display = "none"
  }

  showCheckboxes() {
    if (this.hasSpinnerTarget) this.spinnerTarget.style.display = "none"
    if (this.hasCheckboxesTarget) this.checkboxesTarget.style.display = ""
  }
}
