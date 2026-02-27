import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  static targets = ["modal", "form"]

  connect() {
    this.boundKeydown = this.keydown.bind(this)
  }

  open(event) {
    event.preventDefault()
    if (!this.hasModalTarget) return

    this.modalTarget.classList.remove("hidden")
    document.addEventListener("keydown", this.boundKeydown)
  }

  close(event) {
    event?.preventDefault()
    if (!this.hasModalTarget) return

    this.modalTarget.classList.add("hidden")
    document.removeEventListener("keydown", this.boundKeydown)
  }

  confirm(event) {
    event.preventDefault()
    if (!this.hasFormTarget) return

    this.formTarget.requestSubmit()
  }

  keydown(event) {
    if (event.key === "Escape") this.close(event)
  }
}

