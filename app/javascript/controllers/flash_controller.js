import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  static targets = ["message"]
  static values = {
    timeout: Number
  }

  connect() {
    setTimeout(() => {
      this.fadeOut()
    }, this.timeoutValue || 4000)
  }

  fadeOut() {
    this.messageTarget.classList.add("opacity-0")
    setTimeout(() => this.remove(), 500) // wait for transition to complete
  }
}
