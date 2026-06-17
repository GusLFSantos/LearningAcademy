import { Controller } from "@hotwired/stimulus"

// Accrues *active* reading time on a lesson: counts a second only while the tab
// is visible and the user isn't idle, flushing the total to the server on an
// interval and once more on page hide (via sendBeacon).
export default class extends Controller {
  static values = {
    url: String,
    interval: { type: Number, default: 15 }, // flush cadence (seconds)
    idle: { type: Number, default: 60 }       // seconds of no input => idle
  }

  connect() {
    this.pending = 0
    this.lastActivity = Date.now()

    this.markActivity = () => { this.lastActivity = Date.now() }
    this.activityEvents = ["mousemove", "keydown", "scroll", "click", "touchstart"]
    this.activityEvents.forEach((e) =>
      window.addEventListener(e, this.markActivity, { passive: true })
    )

    this.onHide = () => this.flush(true)
    window.addEventListener("pagehide", this.onHide)
    document.addEventListener("visibilitychange", () => {
      if (document.hidden) this.flush(true)
    })

    this.ticker = setInterval(() => this.accumulate(), 1000)
    this.flusher = setInterval(() => this.flush(), this.intervalValue * 1000)
  }

  disconnect() {
    clearInterval(this.ticker)
    clearInterval(this.flusher)
    this.activityEvents.forEach((e) => window.removeEventListener(e, this.markActivity))
    window.removeEventListener("pagehide", this.onHide)
    this.flush(true)
  }

  accumulate() {
    const idle = Date.now() - this.lastActivity > this.idleValue * 1000
    if (!document.hidden && !idle) this.pending += 1
  }

  flush(useBeacon = false) {
    if (this.pending <= 0 || !this.urlValue) return

    const seconds = this.pending
    this.pending = 0
    const token = document.querySelector('meta[name="csrf-token"]')?.content

    if (useBeacon && navigator.sendBeacon) {
      const data = new FormData()
      data.append("seconds", seconds)
      if (token) data.append("authenticity_token", token)
      navigator.sendBeacon(this.urlValue, data)
      return
    }

    fetch(this.urlValue, {
      method: "POST",
      headers: { "Content-Type": "application/json", "X-CSRF-Token": token || "" },
      body: JSON.stringify({ seconds }),
      keepalive: true
    }).catch(() => { this.pending += seconds }) // restore on failure
  }
}
