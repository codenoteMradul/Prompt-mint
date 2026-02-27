class Prompt < ApplicationRecord
  belongs_to :bundle

  validates :title, :content, presence: true
end
