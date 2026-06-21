import { Controller } from "@hotwired/stimulus"
import {
  applyCollectionCheckboxes,
  checkedCollectionIds,
  collectionDiff,
  hideCollectionsModal,
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
    this.onShow = this.onShow.bind(this)

    if (window.jQuery) {
      window.jQuery(this.element).on("show.bs.modal", this.onShow)
    }
  }

  disconnect() {
    if (window.jQuery) {
      window.jQuery(this.element).off("show.bs.modal", this.onShow)
    }
  }

  onShow(event) {
    const trigger = event.relatedTarget
    if (!trigger) return

    const bookId = parseInt(trigger.dataset.bookId, 10)
    if (Number.isNaN(bookId)) return

    this.bookId = bookId
    this.showLoading()

    loadBookCollections(bookId)
      .then((collections) => {
        this.wasChecked = applyCollectionCheckboxes(this.element, collections)
        this.showCheckboxes()
      })
      .catch(() => {
        this.showCheckboxes()
        notifyCollectionsError(this.errorMessageValue)
        hideCollectionsModal(this.element)
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
        hideCollectionsModal(this.element)
      })
      .catch(() => {
        notifyCollectionsError(this.errorMessageValue)
        hideCollectionsModal(this.element)
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
