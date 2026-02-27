class SessionsController < ApplicationController
  def new
    redirect_to dashboard_path if logged_in?
  end

  def create
    redirect_to dashboard_path if logged_in?

    user = User.find_by(email: params.dig(:session, :email).to_s.strip.downcase)

    if user&.authenticate(params.dig(:session, :password).to_s)
      reset_session
      session[:user_id] = user.id
      redirect_to dashboard_path, notice: "Logged in."
    else
      flash.now[:alert] = "Invalid email or password."
      render :new, status: :unprocessable_entity
    end
  end

  def destroy
    reset_session
    redirect_to login_path, notice: "Logged out."
  end
end
