import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  static targets = ["card", "pill", "categoryField"]

  connect() {
    const category = this.hasCategoryFieldTarget ? this.categoryFieldTarget.value : ""
    if (category) this.applyFilter(category)
    else this.showAll()
  }

  showAll(event) {
    this.#setActivePill(event?.currentTarget || this.pillTargets[0])
    this.cardTargets.forEach((card) => card.classList.remove("hidden"))
    if (this.hasCategoryFieldTarget) this.categoryFieldTarget.value = ""
  }

  filter(event) {
    const category = event.currentTarget.dataset.category
    this.applyFilter(category, event.currentTarget)
  }

  applyFilter(category, pill = null) {
    const activePill = pill || this.pillTargets.find((p) => p.dataset.category === category)
    if (activePill) this.#setActivePill(activePill)

    this.cardTargets.forEach((card) => {
      const matches = card.dataset.category === category
      card.classList.toggle("hidden", !matches)
    })

    if (this.hasCategoryFieldTarget) this.categoryFieldTarget.value = category
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
