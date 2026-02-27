class PurchasesController < ApplicationController
  before_action :require_login

  def index
    @purchases = current_user.purchases.includes(bundle: :prompts).where.not(bundle_id: nil).order(created_at: :desc)
  end
end
