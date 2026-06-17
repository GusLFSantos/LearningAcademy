import { Controller } from "@hotwired/stimulus"

// Renders any <pre class="mermaid"> blocks inside this element. Mermaid is a
// large library, so it is dynamically imported only when a diagram is present.
export default class extends Controller {
  async connect() {
    const nodes = this.element.querySelectorAll("pre.mermaid")
    if (nodes.length === 0) return

    const { default: mermaid } = await import("mermaid")
    mermaid.initialize({ startOnLoad: false, securityLevel: "loose" })
    try {
      await mermaid.run({ nodes })
    } catch (e) {
      console.error("Mermaid render failed", e)
    }
  }
}
