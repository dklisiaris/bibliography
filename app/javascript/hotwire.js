// Hotwire entry (esbuild → app/assets/builds/hotwire.js).
import "@hotwired/turbo"
import "trix"

import "./controllers"
import { initBootstrapBridge } from "./bootstrap_bridge"
import { hideModal } from "./modal"

window.hideModal = hideModal

document.addEventListener("turbo:load", () => {
  initBootstrapBridge()
})
