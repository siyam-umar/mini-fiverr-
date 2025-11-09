class SubmissionsController < ApplicationController
  before_action :authenticate_user!

  def new
    @order = Order.find_by(id: params[:order_id])
    if @order.nil?
      redirect_to freelancer_dashboard_path, alert: "Order not found."
      return
    end
    @submission = Submission.new
  end

  def create
    @order = Order.find_by(id: params[:order_id])
    if @order.nil?
      redirect_to freelancer_dashboard_path, alert: "Order not found."
      return
    end

    @submission = @order.build_submission(submission_params)

    if @submission.save
      @order.update(status: "completed") # optional
      redirect_to freelancer_dashboard_path, notice: "Work submitted successfully!"
    else
      render :new, alert: "Submission failed."
    end
  end

  private

  def submission_params
    params.require(:submission).permit(:file, :message)
  end
end


