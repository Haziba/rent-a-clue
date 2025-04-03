import { Controller } from "@hotwired/stimulus"

// Connects to data-controller="carousel"
export default class extends Controller {
  static targets = ["container"]

  connect() {
  }

  scrollLeft() {
    this.containerTarget.scrollBy({ left: -300, behavior: "smooth" })
  }

  scrollRight() {
    this.containerTarget.scrollBy({ left: 300, behavior: "smooth" })
  }
}
