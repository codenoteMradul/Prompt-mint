class AccountsController < ApplicationController
  before_action :require_login

  def show
    @user = current_user
    @review_count = @user.reviews_received.count
    @average_rating = @user.reviews_received.average(:rating)&.to_f
  end

  def edit
    @user = current_user
  end

  def update
    @user = current_user
    attributes = account_params.to_h

    if attributes["password"].blank?
      attributes.delete("password")
      attributes.delete("password_confirmation")
    end

    if @user.update(attributes)
      redirect_to account_path, notice: "Account updated."
    else
      render :edit, status: :unprocessable_entity
    end
  end

  private

  def account_params
    params.require(:user).permit(
      :avatar,
      :name,
      :phone,
      :country,
      :email,
      :profile_description,
      :years_of_experience,
      :password,
      :password_confirmation
    )
  end
end
