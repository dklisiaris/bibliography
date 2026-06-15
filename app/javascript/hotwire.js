// Hotwire entry (esbuild → app/assets/builds/hotwire.js).
// Legacy UI still loads Sprockets application.js (jQuery, rails-ujs, Bootstrap 3).
import * as Turbo from "@hotwired/turbo"

// Turbo Drive stays off until remote: true links are migrated to Turbo.
Turbo.session.drive = false

import "./controllers"
