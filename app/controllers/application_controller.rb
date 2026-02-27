class ApplicationController < ActionController::Base
  # Only allow modern browsers supporting webp images, web push, badges, import maps, CSS nesting, and CSS :has.
  allow_browser versions: :modern

  helper_method :current_user, :logged_in?
  helper_method :bundle_access_level

  private

  def current_user
    @current_user ||= User.find_by(id: session[:user_id])
  end

  def logged_in?
    current_user.present?
  end

  def require_login
    return if logged_in?

    redirect_to login_path, alert: "Please log in to continue."
  end

  def bundle_access_level(user, bundle)
    return :preview if user.nil?
    return :owner if bundle.user_id == user.id

    purchased = Purchase.exists?(user_id: user.id, bundle_id: bundle.id)
    purchased ? :purchased : :preview
  end
end
