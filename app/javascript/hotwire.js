// Hotwire entry (esbuild → app/assets/builds/hotwire.js).
// Legacy UI still loads Sprockets application.js (jQuery, Bootstrap 3).
import * as Turbo from "@hotwired/turbo"

import "./controllers"

document.addEventListener("turbo:load", () => {
  if (window.App) window.App.init()
})
