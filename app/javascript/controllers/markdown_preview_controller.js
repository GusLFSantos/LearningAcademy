import { Controller } from "@hotwired/stimulus"

// Live Markdown preview: debounced POST of the textarea content to the server
// renderer, injecting the returned HTML into the preview pane.
export default class extends Controller {
  static targets = ["input", "output"]
  static values = { url: String }

  connect() {
    this.update()
  }

  update() {
    clearTimeout(this.timer)
    this.timer = setTimeout(() => this.fetchPreview(), 300)
  }

  async fetchPreview() {
    const token = document.querySelector('meta[name="csrf-token"]')?.content
    try {
      const res = await fetch(this.urlValue, {
        method: "POST",
        headers: { "Content-Type": "application/json", "X-CSRF-Token": token || "" },
        body: JSON.stringify({ text: this.inputTarget.value })
      })
      this.outputTarget.innerHTML = await res.text()
    } catch (e) {
      // Preview is best-effort; ignore transient errors.
    }
  }
}
