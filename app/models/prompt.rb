class Prompt < ApplicationRecord
  enum category: { automation: 0, coding: 1, career: 2 }

  belongs_to :user
  has_many :purchases, dependent: :destroy

  validates :title, :description, :content, :price, :category, presence: true
  validates :price, numericality: { only_integer: true, greater_than_or_equal_to: 0 }
end

