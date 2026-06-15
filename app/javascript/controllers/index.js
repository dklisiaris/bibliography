import { application } from "./application"
import FlashController from "./flash_controller"
import ReadMoreController from "./read_more_controller"

application.register("flash", FlashController)
application.register("read-more", ReadMoreController)

import { showToast } from "../toast"

// Legacy jQuery callers (e.g. collection_manager.js) until migrated to Stimulus.
window.notify = showToast
