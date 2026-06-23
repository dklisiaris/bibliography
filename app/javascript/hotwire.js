// Hotwire entry (esbuild → app/assets/builds/hotwire.js).
// Legacy UI still loads Sprockets application.js (jQuery plugins, ProUI app.js).
import "@hotwired/turbo"

import "./controllers"
import { initBootstrapBridge } from "./bootstrap_bridge"
import { hideModal } from "./modal"

window.hideModal = hideModal

document.addEventListener("turbo:load", () => {
  initBootstrapBridge()
  if (window.App) window.App.init()
})
