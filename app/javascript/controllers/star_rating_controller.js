import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  static targets = ["input", "star"]

  connect() {
    this.render()
  }

  select(event) {
    const value = Number(event.currentTarget.dataset.value)
    const input = this.inputTargets.find((el) => Number(el.value) === value)
    if (!input) return

    input.checked = true
    this.render()
  }

  render() {
    const selected = this.#selectedValue()
    this.starTargets.forEach((star) => {
      const value = Number(star.dataset.value)
      const on = selected && value <= selected
      star.classList.toggle("text-amber-300", on)
      star.classList.toggle("text-white/20", !on)
    })
  }

  #selectedValue() {
    const checked = this.inputTargets.find((el) => el.checked)
    return checked ? Number(checked.value) : null
  }
}

