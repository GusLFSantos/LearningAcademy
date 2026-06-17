# Pin npm packages by running ./bin/importmap

pin "application"
pin "@hotwired/turbo-rails", to: "turbo.min.js"
pin "@hotwired/stimulus", to: "stimulus.min.js"
pin "@hotwired/stimulus-loading", to: "stimulus-loading.js"
# Mermaid diagrams (flattened ESM bundle from jsDelivr — works with importmap).
pin "mermaid", to: "https://cdn.jsdelivr.net/npm/mermaid@11/+esm"
pin_all_from "app/javascript/controllers", under: "controllers"
