// Native title tooltips — no jQuery / Bootstrap JS dependency.
// After dynamic updates, drop data-toggle="tooltip" so BS3 does not show a stale cached title.

export function updateTooltip(element, title) {
  if (!element || title == null) return

  element.setAttribute("title", title)
  element.removeAttribute("data-original-title")

  if (element.getAttribute("data-toggle") === "tooltip") {
    element.removeAttribute("data-toggle")
    element.removeAttribute("data-placement")
  }
}
