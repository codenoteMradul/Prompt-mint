class DashboardController < ApplicationController
  before_action :require_login

  def index
    @bundles = Bundle.includes(:user, :prompts).order(:category, created_at: :desc)
    @purchased_bundle_ids = current_user.purchases.where.not(bundle_id: nil).pluck(:bundle_id)
  end
end
