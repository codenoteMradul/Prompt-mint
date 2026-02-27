import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  static targets = ["category", "section", "input", "preview", "error"]

  connect() {
    this.updateVisibility()
    this.renderPreviews()
  }

  categoryChanged() {
    this.updateVisibility()
    this.renderPreviews()
  }

  filesChanged() {
    this.renderPreviews()
  }

  updateVisibility() {
    if (!this.hasSectionTarget) return

    const isImageGeneration = this.#isImageGeneration()
    this.sectionTarget.classList.toggle("hidden", !isImageGeneration)

    if (!isImageGeneration && this.hasInputTarget) {
      this.inputTarget.value = ""
      if (this.hasPreviewTarget) this.previewTarget.innerHTML = ""
      if (this.hasErrorTarget) this.errorTarget.classList.add("hidden")
    }
  }

  renderPreviews() {
    if (!this.hasInputTarget || !this.hasPreviewTarget) return

    const files = Array.from(this.inputTarget.files || [])
    this.previewTarget.innerHTML = ""

    const tooMany = files.length > 2
    if (this.hasErrorTarget) this.errorTarget.classList.toggle("hidden", !tooMany)

    files.slice(0, 2).forEach((file) => {
      if (!file.type.startsWith("image/")) return

      const url = URL.createObjectURL(file)
      const wrapper = document.createElement("div")
      wrapper.className =
        "relative overflow-hidden rounded-2xl border border-white/10 bg-black/20"

      const img = document.createElement("img")
      img.src = url
      img.alt = "Demo preview"
      img.className = "h-20 w-full object-cover"
      img.onload = () => URL.revokeObjectURL(url)

      wrapper.appendChild(img)
      this.previewTarget.appendChild(wrapper)
    })
  }

  #isImageGeneration() {
    return this.hasCategoryTarget && this.categoryTarget.value === "image_generation"
  }
}
