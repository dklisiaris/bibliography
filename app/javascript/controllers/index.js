import { application } from "./application"
import FlashController from "./flash_controller"
import ReadMoreController from "./read_more_controller"

import FollowController from "./follow_controller"

application.register("flash", FlashController)
application.register("read-more", ReadMoreController)
application.register("follow", FollowController)

import { showToast } from "../toast"

// Legacy jQuery callers (e.g. collection_manager.js) until migrated to Stimulus.
window.notify = showToast
