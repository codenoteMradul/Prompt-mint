import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  sanitize() {
    const digitsOnly = this.element.value.replace(/\D+/g, "")
    if (this.element.value !== digitsOnly) this.element.value = digitsOnly
  }
}

