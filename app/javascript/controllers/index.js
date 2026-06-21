import { application } from "./application"
import FlashController from "./flash_controller"
import ReadMoreController from "./read_more_controller"

import FollowController from "./follow_controller"
import RecommendationController from "./recommendation_controller"
import FavouriteController from "./favourite_controller"

application.register("flash", FlashController)
application.register("read-more", ReadMoreController)
application.register("follow", FollowController)
application.register("recommendation", RecommendationController)
application.register("favourite", FavouriteController)

import { showToast } from "../toast"
import { submitRecommendation } from "../recommendation"
import { submitFavourite } from "../favourite"

// Legacy jQuery callers until migrated to Stimulus.
window.notify = showToast
window.like = (bookId) =>
  submitRecommendation(bookId, "like", window.recommendationLabels).catch(() => {})
window.dislike = (bookId) =>
  submitRecommendation(bookId, "dislike", window.recommendationLabels).catch(() => {})
window.favouriteAuthor = (id) =>
  submitFavourite({
    url: `/authors/${id}/favourite`,
    kind: "author",
    recordId: id,
    inactiveClass: "btn-default",
    labels: window.favouriteAuthorLabels,
  }).catch(() => {})
window.favouriteCategory = (id) =>
  submitFavourite({
    url: `/categories/${id}/favourite`,
    kind: "category",
    recordId: id,
    inactiveClass: "btn-primary",
    labels: window.favouriteCategoryLabels,
  }).catch(() => {})
