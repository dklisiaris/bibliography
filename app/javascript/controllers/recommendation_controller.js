import { Controller } from "@hotwired/stimulus"
import { registerRecommendationLabels, submitRecommendation } from "../recommendation"

export default class extends Controller {
  static values = {
    bookId: Number,
    recommendLabel: String,
    notRecommendLabel: String,
    removeRecommendationLabel: String,
  }

  connect() {
    registerRecommendationLabels(this.bookIdValue, {
      recommend: this.recommendLabelValue,
      notRecommend: this.notRecommendLabelValue,
      removeRecommendation: this.removeRecommendationLabelValue,
    })
  }

  like(event) {
    event.preventDefault()
    submitRecommendation(this.bookIdValue, "like").catch(() => {})
  }

  dislike(event) {
    event.preventDefault()
    submitRecommendation(this.bookIdValue, "dislike").catch(() => {})
  }
}
