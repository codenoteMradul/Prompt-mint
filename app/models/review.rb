class Review < ApplicationRecord
  belongs_to :reviewer, class_name: "User"
  belongs_to :seller, class_name: "User"

  validates :rating, presence: true, inclusion: { in: 1..5 }
  validates :seller_id, uniqueness: { scope: :reviewer_id }
  validate :reviewer_must_be_verified_buyer
  validate :reviewer_cannot_review_self

  after_create_commit :recalculate_creator_ranks

  private

  def reviewer_must_be_verified_buyer
    return if reviewer_id.blank? || seller_id.blank?

    purchased = Purchase.joins(:bundle)
                        .where(user_id: reviewer_id, bundles: { user_id: seller_id })
                        .exists?

    unless purchased
      errors.add(:base, "You can only review sellers whose bundle you have purchased.")
    end
  end

  def reviewer_cannot_review_self
    return if reviewer_id.blank? || seller_id.blank?
    return unless reviewer_id == seller_id

    errors.add(:base, "You cannot review yourself.")
  end

  def recalculate_creator_ranks
    CreatorRankingService.recalculate_all!
  end
end
