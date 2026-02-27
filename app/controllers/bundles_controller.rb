class BundlesController < ApplicationController
  before_action :require_login, except: [ :index, :show ]
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
    @access_level = bundle_access_level(current_user, @bundle)
    @owner = @access_level == :owner
    @unlocked = @owner || @access_level == :purchased
  end

  private

  def set_bundle
    @bundle = Bundle.with_attached_demo_images.includes(:user, :prompts).find(params[:id])
  end

  def bundle_params
    params.require(:bundle).permit(
      :title,
      :description,
      :category,
      :price,
      { demo_images: [] },
      prompts_attributes: [ :id, :title, :content, :_destroy ]
    )
  end
end
