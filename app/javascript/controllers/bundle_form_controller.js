import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  static targets = ["list", "template", "item", "count", "removeButton", "destroyField", "submit", "panel", "titlePreview", "clientError"]
  static values = { min: Number }

  connect() {
    this.#collapseAll()
    this.#expandFirst()
    this.syncAllTitles()
    this.refresh()
  }

  add() {
    const html = this.templateTarget.innerHTML.replaceAll("NEW_RECORD", String(Date.now()))
    this.listTarget.insertAdjacentHTML("beforeend", html)
    const newItem = this.itemTargets[this.itemTargets.length - 1]
    if (newItem) this.#expandOnly(newItem)
    this.refresh()
  }

  remove(event) {
    const item = event.currentTarget.closest("[data-bundle-form-target='item']")
    if (!item) return

    const activeCount = this.activeItems().length
    if (activeCount <= 1) return

    const destroyField = item.querySelector("input[name*='[_destroy]']")
    if (destroyField) destroyField.value = "1"

    item.classList.add("hidden")
    if (item.dataset.expanded === "true") this.#expandFirst()
    this.refresh()
  }

  toggle(event) {
    const item = event.currentTarget.closest("[data-bundle-form-target='item']")
    if (!item) return

    if (item.dataset.expanded === "true") {
      this.#collapse(item)
    } else {
      this.#expandOnly(item)
    }
  }

  syncTitle(event) {
    const input = event.currentTarget
    const item = input.closest("[data-bundle-form-target='item']")
    if (!item) return

    const title = input.value.trim()
    const preview = item.querySelector("[data-bundle-form-target='titlePreview']")
    if (preview) preview.textContent = title.length ? title : "Untitled prompt"
  }

  syncAllTitles() {
    this.itemTargets.forEach((item) => {
      const input = item.querySelector("input[name*='[title]']")
      if (!input) return
      const title = input.value.trim()
      const preview = item.querySelector("[data-bundle-form-target='titlePreview']")
      if (preview) preview.textContent = title.length ? title : "Untitled prompt"
    })
  }

  submitAttempt(event) {
    this.hideClientError()
    if (this.activeItems().length >= this.minValue) return

    event.preventDefault()
    this.showClientError()
    this.#shakeError()
  }

  refresh() {
    this.hideClientError()
    const count = this.activeItems().length
    this.countTarget.textContent = String(count)

    const canRemove = count > 1
    this.removeButtonTargets.forEach((button) => {
      button.disabled = !canRemove
    })

    if (this.hasSubmitTarget) {
      this.submitTarget.disabled = count < this.minValue
    }
  }

  activeItems() {
    return this.itemTargets.filter((item) => {
      if (item.classList.contains("hidden")) return false
      const destroyField = item.querySelector("input[name*='[_destroy]']")
      return !destroyField || destroyField.value !== "1"
    })
  }

  showClientError() {
    if (this.hasClientErrorTarget) this.clientErrorTarget.classList.remove("hidden")
  }

  hideClientError() {
    if (this.hasClientErrorTarget) this.clientErrorTarget.classList.add("hidden")
  }

  #shakeError() {
    if (!this.hasClientErrorTarget) return
    this.clientErrorTarget.classList.remove("animate-pulse")
    void this.clientErrorTarget.offsetWidth
    this.clientErrorTarget.classList.add("animate-pulse")
  }

  #collapseAll() {
    this.itemTargets.forEach((item) => this.#collapse(item))
  }

  #expandFirst() {
    const first = this.activeItems()[0]
    if (first) this.#expandOnly(first)
  }

  #expandOnly(itemToExpand) {
    this.activeItems().forEach((item) => {
      if (item === itemToExpand) this.#expand(item)
      else this.#collapse(item)
    })
  }

  #expand(item) {
    const panel = item.querySelector("[data-bundle-form-target='panel']")
    if (!panel) return

    item.dataset.expanded = "true"
    panel.classList.remove("max-h-0", "opacity-0")
    panel.classList.add("max-h-[2000px]", "opacity-100")
  }

  #collapse(item) {
    const panel = item.querySelector("[data-bundle-form-target='panel']")
    if (!panel) return

    item.dataset.expanded = "false"
    panel.classList.add("max-h-0", "opacity-0")
    panel.classList.remove("max-h-[2000px]", "opacity-100")
  }
}
