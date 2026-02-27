class LeaderboardController < ApplicationController
  def index
    @creators = User.where.not(rank_position: nil)
                    .order(rank_position: :asc)
                    .limit(20)
                    .includes(avatar_attachment: :blob)

    creator_ids = @creators.map(&:id)
    @average_ratings = Review.where(seller_id: creator_ids).group(:seller_id).average(:rating)
    @review_counts = Review.where(seller_id: creator_ids).group(:seller_id).count
    @sales_counts = Purchase.joins(:bundle).where(bundles: { user_id: creator_ids }).group("bundles.user_id").count
  end
end

