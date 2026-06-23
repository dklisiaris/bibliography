// Hotwire entry (esbuild → app/assets/builds/hotwire.js).
// Legacy UI still loads Sprockets application.js (jQuery plugins, ProUI app.js).
import * as Turbo from "@hotwired/turbo"

import "./controllers"
import { initBootstrapBridge } from "./bootstrap_bridge"
import { hideBs3Modal } from "./bs3_modal"
import { hideModal } from "./modal"

window.hideBs3Modal = hideBs3Modal
window.hideModal = hideModal

document.addEventListener("turbo:load", () => {
  initBootstrapBridge()
  if (window.App) window.App.init()
})
