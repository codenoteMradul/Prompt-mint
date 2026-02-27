class DashboardController < ApplicationController
  before_action :require_login

  def index
    @bundles = Bundle.includes(:user, :prompts).order(:category, created_at: :desc)

    if params[:category].present? && Bundle.categories.key?(params[:category].to_s)
      @bundles = @bundles.where(category: params[:category])
    end

    if params[:query].present?
      query = params[:query].to_s.strip
      if query.present?
        like = "%#{ActiveRecord::Base.sanitize_sql_like(query)}%"
        normalized = query.downcase
        matching_category_ids = Bundle.categories.select do |key, _|
          label = key.to_s.tr("_", " ")
          label.include?(normalized) || key.to_s.include?(normalized)
        end.values

        @bundles = @bundles
          .left_joins(:user)
          .where(
            "bundles.title ILIKE :q OR users.name ILIKE :q OR bundles.category IN (:cats)",
            q: like,
            cats: matching_category_ids.presence || [ -1 ]
          )
      end
    end

    @purchased_bundle_ids = current_user.purchases.where.not(bundle_id: nil).pluck(:bundle_id)
  end
end
