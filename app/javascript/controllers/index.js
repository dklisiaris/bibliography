import { application } from "./application"
import FlashController from "./flash_controller"
import ReadMoreController from "./read_more_controller"

import FollowController from "./follow_controller"
import RecommendationController from "./recommendation_controller"
import FavouriteController from "./favourite_controller"
import CollectionsModalController from "./collections_modal_controller"
import AutocompleteController from "./autocomplete_controller"
import FilterSidebarController from "./filter_sidebar_controller"
import ReviewModalController from "./review_modal_controller"
import AppShellController from "./app_shell_controller"

application.register("flash", FlashController)
application.register("read-more", ReadMoreController)
application.register("follow", FollowController)
application.register("recommendation", RecommendationController)
application.register("favourite", FavouriteController)
application.register("collections-modal", CollectionsModalController)
application.register("autocomplete", AutocompleteController)
application.register("filter-sidebar", FilterSidebarController)
application.register("review-modal", ReviewModalController)
application.register("app-shell", AppShellController)

import { submitRecommendation } from "../recommendation"
import { submitFavourite } from "../favourite"

// Legacy jQuery callers until migrated to Stimulus.
window.like = (bookId) =>
  submitRecommendation(bookId, "like", window.recommendationLabels).catch(() => {})
window.dislike = (bookId) =>
  submitRecommendation(bookId, "dislike", window.recommendationLabels).catch(() => {})
window.favouriteAuthor = (id) =>
  submitFavourite({
    url: `/authors/${id}/favourite`,
    kind: "author",
    recordId: id,
    inactiveClass: "btn-outline-secondary",
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
