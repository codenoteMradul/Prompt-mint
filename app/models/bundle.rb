class Bundle < ApplicationRecord
  enum :category, { automation: 0, coding: 1, career: 2, image_generation: 3, creative: 4 }

  has_many_attached :demo_images

  scope :active, -> { where(deleted: false) }

  belongs_to :user
  has_many :prompts, dependent: :destroy, inverse_of: :bundle
  accepts_nested_attributes_for :prompts, allow_destroy: true

  validates :title, :description, :price, :category, presence: true
  validates :price, numericality: { only_integer: true, greater_than_or_equal_to: 0 }
  validate :must_have_minimum_prompts
  validate :demo_images_requirements

  MIN_PROMPTS = 10
  MAX_DEMO_IMAGES = 2

  private

  def must_have_minimum_prompts
    prompt_count = prompts.reject(&:marked_for_destruction?).count { |p| p.title.present? && p.content.present? }
    if prompt_count < MIN_PROMPTS
      errors.add(:base, "Bundle must include at least #{MIN_PROMPTS} prompts.")
    end
  end

  def demo_images_requirements
    if image_generation? && !demo_images.attached?
      errors.add(:demo_images, "is required for Image Generation bundles")
      return
    end

    return unless demo_images.attached?

    if demo_images.size > MAX_DEMO_IMAGES
      errors.add(:demo_images, "maximum #{MAX_DEMO_IMAGES} images allowed")
    end

    demo_images.each do |image|
      unless image.content_type.to_s.start_with?("image/")
        errors.add(:demo_images, "must be image files")
      end

      if image.blob&.byte_size.to_i > 5.megabytes
        errors.add(:demo_images, "each image must be smaller than 5MB")
      end
    end
  end
end
