class ReviewsController < ApplicationController
  before_action :authenticate_user!
  before_action :set_service

  def create
    @review = @service.reviews.build(review_params.merge(user: current_user))

    respond_to do |format|
      if @review.save
        format.turbo_stream
        format.html { redirect_to @service, notice: "Review submitted successfully!" }
      else
        format.turbo_stream
        format.html { redirect_to @service, alert: "Failed to submit review." }
      end
    end
  end

  private

  def set_service
    @service = Service.find_by(id: params[:service_id])
    unless @service
      redirect_to services_path, alert: "Service not found."
    end
  end

  def review_params
    params.require(:review).permit(:rating, :comment)
  end
end



