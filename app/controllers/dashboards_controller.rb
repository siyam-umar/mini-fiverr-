class DashboardsController < ApplicationController
  before_action :authenticate_user!

  def client
    @orders = current_user.orders.includes(:service)
  end

  def freelancer
    @orders = Order.joins(:service).where(services: { user_id: current_user.id }).includes(:user, :service)
  end
end
