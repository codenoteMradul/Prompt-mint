import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  static targets = ["card", "pill"]

  connect() {
    this.showAll()
  }

  showAll(event) {
    this.#setActivePill(event?.currentTarget || this.pillTargets[0])
    this.cardTargets.forEach((card) => card.classList.remove("hidden"))
  }

  filter(event) {
    const category = event.currentTarget.dataset.category
    this.#setActivePill(event.currentTarget)

    this.cardTargets.forEach((card) => {
      const matches = card.dataset.category === category
      card.classList.toggle("hidden", !matches)
    })
  }

  #setActivePill(activePill) {
    this.pillTargets.forEach((pill) => {
      const isActive = pill === activePill
      pill.classList.toggle("bg-white/10", isActive)
      pill.classList.toggle("border-white/20", isActive)
      pill.classList.toggle("text-white", isActive)
    })
  }
}
