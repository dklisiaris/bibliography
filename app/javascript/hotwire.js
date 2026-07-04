// Hotwire entry (esbuild → app/assets/builds/hotwire.js).
import "@hotwired/turbo"
import "trix"

import "./controllers"
import { initAnalytics } from "./analytics"
import { initBootstrapBridge } from "./bootstrap_bridge"
import { hideModal } from "./modal"

window.hideModal = hideModal

initAnalytics()

document.addEventListener("turbo:load", () => {
  initBootstrapBridge()
})
