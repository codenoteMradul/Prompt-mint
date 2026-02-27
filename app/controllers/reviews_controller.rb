class ReviewsController < ApplicationController
  before_action :require_login

  def create
    seller = User.find(params[:user_id])

    review = current_user.reviews_given.new(review_params.merge(seller:))

    if review.save
      redirect_to user_path(seller), notice: "Review submitted."
    else
      redirect_to user_path(seller), alert: review.errors.full_messages.to_sentence
    end
  end

  private

  def review_params
    params.require(:review).permit(:rating, :comment)
  end
end

