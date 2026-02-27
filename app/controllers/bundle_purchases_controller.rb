class BundlePurchasesController < ApplicationController
  before_action :require_login

  def create
    bundle = Bundle.includes(:prompts).find(params[:bundle_id])

    if bundle.user_id == current_user.id
      redirect_to dashboard_path, alert: "You already own this bundle."
      return
    end

    purchase = current_user.purchases.find_or_initialize_by(bundle:)

    if purchase.persisted?
      redirect_to dashboard_path, notice: "You already purchased this bundle."
      return
    end

    if purchase.save
      redirect_to dashboard_path, notice: "Bundle unlocked."
    else
      redirect_to dashboard_path, alert: "Could not unlock bundle."
    end
  end
end
