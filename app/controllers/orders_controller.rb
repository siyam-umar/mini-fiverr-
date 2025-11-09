class OrdersController < ApplicationController
  before_action :authenticate_user!
  before_action :check_client, only: [:index, :create]

  def index
    @orders = current_user.orders.includes(:service)
  end

  def accept
    @order = Order.find_by(id: params[:id])
    if @order && @order.accepted!
      OrderMailer.order_accepted(@order).deliver_later
      redirect_to freelancer_dashboard_path, notice: "Order accepted!"
    else
      redirect_to freelancer_dashboard_path, alert: "Order not found or could not be accepted."
    end
  end

  def reject
    @order = Order.find_by(id: params[:id])
    if @order
      @order.rejected!
      OrderMailer.order_rejected(@order).deliver_later
      redirect_to freelancer_dashboard_path, alert: "Order rejected"
    else
      redirect_to freelancer_dashboard_path, alert: "Order not found."
    end
  end

  def complete
    @order = Order.find_by(id: params[:id])
    if @order
      @order.completed!
      redirect_to request.referer, notice: "Order marked as completed."
    else
      redirect_to request.referer, alert: "Order not found."
    end
  end

  def client_orders
    @orders = current_user.orders.includes(:service)

    if params[:payment] == 'success' && params[:order_id]
      order = Order.find_by(id: params[:order_id])

      if order && order.payment_status != "paid"
        total_price_cents = (order.service.price * 100).to_i

        success = order.update(
          payment_status: "paid",
          status: :in_progress,
          total_price: total_price_cents
        )

        flash[:notice] = "Payment successful for Order ##{order.id}" if success
      end
    elsif params[:payment] == 'cancel'
      flash[:alert] = "Payment was cancelled."
    end
  end

  def create
    service = Service.find_by(id: params[:service_id])
    if service
      order = current_user.orders.build(service: service, status: :pending, payment_status: "unpaid")

      if order.save
        redirect_to service_path(service), notice: "Order placed successfully!"
      else
        redirect_to service_path(service), alert: "Failed to place order."
      end
    else
      redirect_to root_path, alert: "Service not found."
    end
  end

  def update_status
    @order = Order.find_by(id: params[:id])

    if @order && @order.freelancer == current_user
      new_status = params[:status]

      if Order.statuses.key?(new_status) # check enum keys
        @order.update(status: new_status)
        redirect_to orders_path, notice: "Order status updated to #{new_status.humanize}."
      else
        redirect_to orders_path, alert: "Invalid status."
      end
    else
      redirect_to orders_path, alert: "Order not found or you are not authorized."
    end
  end

  def create_checkout_session
    @order = Order.find_by(id: params[:id])
    if @order
      session = Stripe::Checkout::Session.create({
        payment_method_types: ['card'],
        line_items: [{
          price_data: {
            currency: 'usd',
            product_data: {
              name: "Payment for Order ##{@order.id}"
            },
            unit_amount: (@order.service.price * 100).to_i
          },
          quantity: 1,
        }],
        mode: 'payment',
        success_url: my_orders_url(payment: 'success', order_id: @order.id),
        cancel_url: my_orders_url(payment: 'cancel')
      })

      redirect_to session.url, allow_other_host: true
    else
      redirect_to orders_path, alert: "Order not found."
    end
  end

  private

  def check_client
    redirect_to root_path, alert: "Only clients can place orders." unless current_user.role == "client"
  end
end



