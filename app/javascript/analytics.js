// Legacy Universal Analytics (UA-61773702-1). Loaded from the bundle so CSP
// script-src stays :self / :https without unsafe-inline.
const GA_ID = "UA-61773702-1"

function analyticsEnabled() {
  return document.querySelector('meta[name="google-analytics-id"]') !== null
}

function loadGoogleAnalytics() {
  if (!analyticsEnabled() || typeof window.ga === "function") return

  window.ga =
    window.ga ||
    function gaStub() {
      ;(window.ga.q = window.ga.q || []).push(arguments)
    }
  window.ga.l = Date.now()

  const script = document.createElement("script")
  script.async = true
  script.src = "https://www.google-analytics.com/analytics.js"
  document.head.appendChild(script)

  window.ga("create", GA_ID, "auto")
  window.ga("send", "pageview")
}

function trackPageView() {
  if (!analyticsEnabled() || typeof window.ga !== "function") return

  window.ga("set", "page", window.location.pathname + window.location.search)
  window.ga("send", "pageview")
}

export function initAnalytics() {
  if (!analyticsEnabled()) return

  loadGoogleAnalytics()
  document.addEventListener("turbo:load", trackPageView)
}
