import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  connect() {
    const percent = parseFloat(this.element.dataset.percent) || 0
    const barColor = this.element.dataset.barColor || "#777777"
    const trackColor = this.element.dataset.trackColor || "#eeeeee"
    const lineWidth = parseFloat(this.element.dataset.lineWidth) || 3
    const size = parseFloat(this.element.dataset.size) || 80

    let canvas = this.element.querySelector("canvas")
    if (!canvas) {
      canvas = document.createElement("canvas")
      this.element.appendChild(canvas)
    }

    const ratio = window.devicePixelRatio > 1 ? window.devicePixelRatio : 1
    canvas.width = size * ratio
    canvas.height = size * ratio
    canvas.style.width = `${size}px`
    canvas.style.height = `${size}px`

    const ctx = canvas.getContext("2d")
    ctx.scale(ratio, ratio)

    const radius = size / 2 - lineWidth / 2
    const center = size / 2

    ctx.clearRect(0, 0, size, size)

    ctx.beginPath()
    ctx.arc(center, center, radius, 0, Math.PI * 2)
    ctx.strokeStyle = trackColor
    ctx.lineWidth = lineWidth
    ctx.stroke()

    if (percent > 0) {
      ctx.beginPath()
      ctx.arc(center, center, radius, -Math.PI / 2, -Math.PI / 2 + (Math.PI * 2 * percent) / 100)
      ctx.strokeStyle = barColor
      ctx.lineWidth = lineWidth
      ctx.lineCap = "round"
      ctx.stroke()
    }
  }
}
