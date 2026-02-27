class BundlesController < ApplicationController
  before_action :require_login
  before_action :set_bundle, only: :show

  def index
    @bundles = Bundle.includes(:user, :prompts).order(created_at: :desc)
  end

  def new
    @bundle = current_user.bundles.new
    @bundle.prompts.build
  end

  def create
    @bundle = current_user.bundles.new(bundle_params)

    if @bundle.save
      redirect_to dashboard_path, notice: "Bundle created."
    else
      @bundle.prompts.build if @bundle.prompts.empty?
      render :new, status: :unprocessable_entity
    end
  end

  def show
    @owner = @bundle.user_id == current_user.id
    @unlocked = @owner || current_user.purchases.exists?(bundle_id: @bundle.id)
  end

  private

  def set_bundle
    @bundle = Bundle.includes(:prompts).find(params[:id])
  end

  def bundle_params
    params.require(:bundle).permit(:title, :description, :category, :price, prompts_attributes: [ :id, :title, :content, :_destroy ])
  end
end
