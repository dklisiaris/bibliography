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
import ProfileModalController from "./profile_modal_controller"
import ProfileUploadController from "./profile_upload_controller"
import PieChartController from "./pie_chart_controller"
import BookCommentsController from "./book_comments_controller"
import ReviewPostController from "./review_post_controller"
import WelcomeWizardController from "./welcome_wizard_controller"

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
application.register("profile-modal", ProfileModalController)
application.register("profile-upload", ProfileUploadController)
application.register("pie-chart", PieChartController)
application.register("book-comments", BookCommentsController)
application.register("review-post", ReviewPostController)
application.register("welcome-wizard", WelcomeWizardController)
