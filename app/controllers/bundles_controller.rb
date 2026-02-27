class BundlesController < ApplicationController
  before_action :require_login, except: [ :index, :show ]
  before_action :set_bundle, only: [ :show, :edit, :update, :destroy ]
  before_action :authorize_owner!, only: [ :edit, :update, :destroy ]

  def index
    @bundles = Bundle.active.includes(:user, :prompts).order(created_at: :desc)
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

    if @bundle.deleted? && !(@owner || @unlocked)
      redirect_to(logged_in? ? dashboard_path : root_path, alert: "This bundle was removed from the marketplace.") and return
    end
  end

  def edit
  end

  def update
    if @bundle.update(bundle_params)
      redirect_to bundle_path(@bundle), notice: "Bundle updated."
    else
      @bundle.prompts.build if @bundle.prompts.empty?
      render :edit, status: :unprocessable_entity
    end
  end

  def destroy
    @bundle.update!(deleted: true)
    redirect_to dashboard_path, notice: "Bundle removed from marketplace."
  end

  private

  def set_bundle
    @bundle = Bundle.with_attached_demo_images.includes(:user, :prompts).find(params[:id])
  end

  def authorize_owner!
    return if @bundle.user_id == current_user.id

    redirect_to dashboard_path, alert: "You are not authorized to do that."
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
