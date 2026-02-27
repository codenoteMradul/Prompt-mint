class CreatorRankingService
  SCORE_FROM_RATING = 50
  SCORE_FROM_EXPERIENCE = 10
  SCORE_FROM_SALES = 5

  def self.recalculate_all!
    creator_ids = Bundle.distinct.pluck(:user_id)
    now = Time.current

    if creator_ids.empty?
      User.update_all(ranking_score: 0.0, rank_position: nil, updated_at: now)
      return
    end

    average_ratings = Review.where(seller_id: creator_ids).group(:seller_id).average(:rating)
    sales_counts = Purchase.joins(:bundle).where(bundles: { user_id: creator_ids }).group("bundles.user_id").count
    experience_by_user = User.where(id: creator_ids).pluck(:id, :years_of_experience).to_h

    scored = creator_ids.map do |user_id|
      rating = average_ratings[user_id].to_f
      years = experience_by_user[user_id].to_i
      sales = sales_counts[user_id].to_i

      score = (rating * SCORE_FROM_RATING) + (years * SCORE_FROM_EXPERIENCE) + (sales * SCORE_FROM_SALES)
      [user_id, score]
    end

    ranked = scored.sort_by { |(id, score)| [ -score, id ] }

    updates = ranked.each_with_index.map do |(id, score), index|
      {
        id: id,
        ranking_score: score.round(2),
        rank_position: index + 1,
        updated_at: now
      }
    end

    ids = updates.map { |u| u[:id] }
    score_cases = updates.map { |u| "WHEN #{u[:id]} THEN #{u[:ranking_score]}" }.join(" ")
    position_cases = updates.map { |u| "WHEN #{u[:id]} THEN #{u[:rank_position]}" }.join(" ")

    User.where(id: ids).update_all(
      [
        "ranking_score = CASE id #{score_cases} END, rank_position = CASE id #{position_cases} END, updated_at = ?",
        now
      ]
    )

    User.where.not(id: creator_ids).update_all(ranking_score: 0.0, rank_position: nil, updated_at: now)
  end
end
