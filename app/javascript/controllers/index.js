import { application } from "./application"
import FlashController from "./flash_controller"
import ReadMoreController from "./read_more_controller"

import FollowController from "./follow_controller"
import RecommendationController from "./recommendation_controller"

application.register("flash", FlashController)
application.register("read-more", ReadMoreController)
application.register("follow", FollowController)
application.register("recommendation", RecommendationController)

import { showToast } from "../toast"
import { submitRecommendation } from "../recommendation"

// Legacy jQuery callers until migrated to Stimulus.
window.notify = showToast
window.like = (bookId) =>
  submitRecommendation(bookId, "like", window.recommendationLabels).catch(() => {})
window.dislike = (bookId) =>
  submitRecommendation(bookId, "dislike", window.recommendationLabels).catch(() => {})
