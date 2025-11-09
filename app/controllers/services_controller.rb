class ServicesController < ApplicationController
  before_action :authenticate_user!
  before_action :check_freelancer, only: [:new, :create]
  before_action :set_service, only: [:show, :edit, :update, :destroy]
  before_action :authorize_user!, only: [:edit, :update, :destroy]

  def index
    if params[:query].present?
      @services = Service.where("title ILIKE ? OR description ILIKE ?", "%#{params[:query]}%", "%#{params[:query]}%")
    else
      @services = Service.all
    end
  end

  def show
    # @service already set by set_service
  end

  def new
    @service = current_user.services.build
  end

  def create
    @service = current_user.services.build(service_params)
    if @service.save
      redirect_to @service, notice: "✅ Service posted successfully."
    else
      render :new, status: :unprocessable_entity
    end
  end

  def edit
  end

  def update
    if @service.update(service_params)
      redirect_to @service, notice: "✅ Service updated successfully."
    else
      render :edit, status: :unprocessable_entity
    end
  end

  def destroy
    @service.destroy
    redirect_to services_path, notice: "🗑️ Service deleted successfully."
  end

  private

  def set_service
    @service = Service.find_by(id: params[:id])
    redirect_to services_path, alert: "Service not found." if @service.nil?
  end

  def service_params
    params.require(:service).permit(:title, :description, :price)
  end

  def check_freelancer
    unless current_user.role == "freelancer"
      redirect_to root_path, alert: "⚠️ Only freelancers can post services."
    end
  end

  def authorize_user!
    if @service && @service.user != current_user
      redirect_to services_path, alert: "⛔ You are not authorized to modify this service."
    end
  end
end



