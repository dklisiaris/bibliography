import { application } from "./application"
import FlashController from "./flash_controller"

application.register("flash", FlashController)

import { showToast } from "../toast"

// Legacy jQuery callers (e.g. collection_manager.js) until migrated to Stimulus.
window.notify = showToast
