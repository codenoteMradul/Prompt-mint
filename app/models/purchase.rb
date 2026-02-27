class Purchase < ApplicationRecord
  belongs_to :user
  belongs_to :bundle

  validates :bundle_id, uniqueness: { scope: :user_id }
end
