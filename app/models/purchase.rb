class Purchase < ApplicationRecord
  belongs_to :user
  belongs_to :bundle

  validates :bundle_id, uniqueness: { scope: :user_id }

  after_create_commit :recalculate_creator_ranks

  private

  def recalculate_creator_ranks
    CreatorRankingService.recalculate_all!
  end
end
