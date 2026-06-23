import { Controller } from "@hotwired/stimulus"
import Masonry from "masonry-layout"
import { initBootstrapBridge } from "../bootstrap_bridge"
import { submitFavourite } from "../favourite"
import { submitRecommendation } from "../recommendation"

export default class extends Controller {
  static values = {
    email: String,
    token: String,
    recommendationLabels: Object,
    favouriteCategoryLabels: Object,
  }

  static targets = [
    "progressBar",
    "stepFirst",
    "stepSecond",
    "stepThird",
    "rateableBooks",
    "backBtn",
    "nextBtn",
  ]

  connect() {
    this.currentStep = 1
    this.updateProgressBar(33, "bg-danger")
    this.hide(this.stepSecondTarget, this.stepThirdTarget)
    this.show(this.stepFirstTarget)
  }

  next(event) {
    event.preventDefault()
    if (this.currentStep >= 3) return
    this.currentStep += 1
    this.handleStepChange()
  }

  back(event) {
    event.preventDefault()
    if (this.currentStep <= 1) return
    this.currentStep -= 1
    this.handleStepChange()
  }

  toggleCategory(event) {
    event.preventDefault()
    const label = event.currentTarget
    const categoryId = label.getAttribute("for")?.replace("category-", "")
    if (!categoryId) return

    label.classList.toggle("selected")

    submitFavourite({
      url: `/categories/${categoryId}/favourite`,
      kind: "category",
      recordId: categoryId,
      inactiveClass: "btn-primary",
      labels: this.favouriteCategoryLabelsValue,
    }).catch(() => {
      label.classList.toggle("selected")
    })
  }

  rateBook(event) {
    const button = event.target.closest(".btn-like, .btn-dislike")
    if (!button) return

    const match = button.className.match(/btn-(like|dislike)-(\d+)/)
    if (!match) return

    const action = match[1]
    const bookId = match[2]

    submitRecommendation(bookId, action, this.recommendationLabelsValue).catch(() => {})
  }

  handleStepChange() {
    if (this.currentStep === 1) {
      this.hide(this.stepSecondTarget, this.stepThirdTarget)
      this.show(this.stepFirstTarget)
      this.updateProgressBar(33, "bg-danger")
    } else if (this.currentStep === 2) {
      this.hide(this.stepFirstTarget, this.stepThirdTarget)
      this.show(this.stepSecondTarget)
      this.updateProgressBar(66, "bg-info")
      this.loadRateableBooks()
    } else if (this.currentStep === 3) {
      this.hide(this.stepFirstTarget, this.stepSecondTarget)
      this.show(this.stepThirdTarget)
      this.updateProgressBar(100, "bg-success")
      window.location.replace(window.location.origin)
    }
  }

  loadRateableBooks() {
    this.rateableBooksTarget.innerHTML = ""
    this.rateableBooksTarget.classList.add("loading")

    this.fetchRatedIds()
      .then((rated) => this.fetchCategoriesWithBooks().then((categories) => ({ rated, categories })))
      .then(({ rated, categories }) => {
        categories.categories.forEach((category) => {
          this.rateableBooksTarget.insertAdjacentHTML("beforeend", this.categorySectionHtml(category, rated))
        })

        this.rateableBooksTarget.classList.remove("loading")

        this.rateableBooksTarget.querySelectorAll(".book-container").forEach((container) => {
          new Masonry(container, {
            itemSelector: ".rateable-book",
            columnWidth: 44,
            gutter: 12,
            fitWidth: true,
          })
        })

        initBootstrapBridge()
      })
      .catch(() => {
        this.rateableBooksTarget.classList.remove("loading")
      })
  }

  fetchRatedIds() {
    return fetch("/api/v1/books/rated_ids/", {
      headers: this.authHeaders(),
    }).then((response) => {
      if (!response.ok) throw new Error("rated_ids failed")
      return response.json()
    })
  }

  fetchCategoriesWithBooks() {
    return fetch("/api/v1/categories/liked_with_books/", {
      headers: this.authHeaders(),
    }).then((response) => {
      if (!response.ok) throw new Error("liked_with_books failed")
      return response.json()
    })
  }

  authHeaders() {
    return {
      Authorization: `Token token="${this.tokenValue}", email="${this.emailValue}"`,
      Accept: "application/json",
    }
  }

  categorySectionHtml(category, rated) {
    const booksHtml =
      category.books.length > 0
        ? category.books.map((book) => this.rateableBookHtml(book, rated)).join("")
        : `<div class="text-center"><span class="text-muted"><small>Δεν υπάρχουν βιβλία ακόμα.</small></span></div>`

    return `
      <section class="static-page__wizard-category">
        <header class="static-page__wizard-category-header">${category.name}</header>
        <div class="static-page__wizard-category-body">
          <div class="book-container">${booksHtml}</div>
        </div>
      </section>
    `
  }

  rateableBookHtml(book, rated) {
    const liked = rated.liked_book_ids.some((id) => String(id) === String(book.id))
    const disliked = rated.disliked_book_ids.some((id) => String(id) === String(book.id))
    const likeClass = liked ? "btn-success" : "btn-outline-secondary"
    const dislikeClass = disliked ? "btn-danger" : "btn-outline-secondary"

    return `
      <div class="rateable-book">
        <div class="book-cover">
          <img height="114" width="114" title="${book.title}" src="${book.cover}" alt="book_cover" class="img-thumbnail" data-bs-toggle="tooltip" data-bs-placement="top" />
        </div>
        <button name="button" type="button" class="btn btn-sm btn-like btn-like-${book.id} ${likeClass}">
          <i class="fa fa-thumbs-up"></i>
        </button>
        <button name="button" type="button" class="btn btn-sm btn-dislike btn-dislike-${book.id} ${dislikeClass}">
          <i class="fa fa-thumbs-down"></i>
        </button>
      </div>
    `
  }

  updateProgressBar(width, colorClass) {
    this.progressBarTarget.style.width = `${width}%`
    this.progressBarTarget.setAttribute("aria-valuenow", String(width))
    this.progressBarTarget.classList.remove("bg-danger", "bg-info", "bg-success")
    this.progressBarTarget.classList.add(colorClass)
  }

  show(...elements) {
    elements.forEach((el) => {
      el.hidden = false
    })
  }

  hide(...elements) {
    elements.forEach((el) => {
      el.hidden = true
    })
  }
}
