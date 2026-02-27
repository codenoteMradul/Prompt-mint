class UsersController < ApplicationController
  def new
    redirect_to dashboard_path if logged_in?

    @user = User.new
  end

  def show
    @user = User.find(params[:id])
    @bundles = @user.bundles.includes(:user, :prompts).order(created_at: :desc)

    @total_bundles = @bundles.size
    @total_bundles_sold = Purchase.joins(:bundle).where(bundles: { user_id: @user.id }).count

    @purchased_bundle_ids = logged_in? ? current_user.purchases.where.not(bundle_id: nil).pluck(:bundle_id) : []

    @review_count = @user.reviews_received.count
    @average_rating = @user.reviews_received.average(:rating)&.to_f
    @reviews = @user.reviews_received.includes(:reviewer).order(created_at: :desc)
    @verified_buyer_ids = Purchase.joins(:bundle)
                                  .where(bundles: { user_id: @user.id })
                                  .distinct
                                  .pluck(:user_id)

    @can_review = false
    if logged_in? && current_user.id != @user.id
      purchased_from_seller = Purchase.joins(:bundle)
                                      .where(user_id: current_user.id, bundles: { user_id: @user.id })
                                      .exists?
      already_reviewed = Review.exists?(reviewer_id: current_user.id, seller_id: @user.id)
      @can_review = purchased_from_seller && !already_reviewed
    end
  end

  def create
    redirect_to dashboard_path if logged_in?

    @user = User.new(user_params)

    if @user.save
      reset_session
      session[:user_id] = @user.id
      redirect_to dashboard_path, notice: "Account created."
    else
      render :new, status: :unprocessable_entity
    end
  end

  private

  def user_params
    params.require(:user).permit(:name, :phone, :country, :email, :password, :password_confirmation)
  end
end
