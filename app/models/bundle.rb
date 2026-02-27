class Bundle < ApplicationRecord
  enum :category, { automation: 0, coding: 1, career: 2 }

  belongs_to :user
  has_many :prompts, dependent: :destroy, inverse_of: :bundle
  accepts_nested_attributes_for :prompts, allow_destroy: true

  validates :title, :description, :price, :category, presence: true
  validates :price, numericality: { only_integer: true, greater_than_or_equal_to: 0 }
  validate :must_have_minimum_prompts

  MIN_PROMPTS = 10

  private

  def must_have_minimum_prompts
    prompt_count = prompts.reject(&:marked_for_destruction?).count { |p| p.title.present? && p.content.present? }
    if prompt_count < MIN_PROMPTS
      errors.add(:base, "Bundle must include at least #{MIN_PROMPTS} prompts.")
    end
  end
end
