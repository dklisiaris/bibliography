import { Tooltip } from "bootstrap"

// Update tooltip text after dynamic UI changes (recommendations, favourites, collections).
export function updateTooltip(element, title) {
  if (!element || title == null) return

  element.setAttribute("title", title)
  element.removeAttribute("data-original-title")
  element.removeAttribute("data-bs-original-title")

  const instance = Tooltip.getInstance(element)
  if (instance) {
    instance.setContent({ ".tooltip-inner": title })
  }
}
