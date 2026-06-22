import { Controller } from "@hotwired/stimulus"
import { hideBs3Modal, showBs3Modal } from "../bs3_modal"
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
    showBs3Modal(this.element)
    this.showLoading()

    loadBookCollections(bookId)
      .then((collections) => {
        this.wasChecked = applyCollectionCheckboxes(this.element, collections)
        this.showCheckboxes()
      })
      .catch(() => {
        this.showCheckboxes()
        notifyCollectionsError(this.errorMessageValue)
        this.close()
      })
  }

  close(event) {
    event?.preventDefault()
    hideBs3Modal(this.element)
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
        this.close()
      })
      .catch(() => {
        notifyCollectionsError(this.errorMessageValue)
        this.close()
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
