class PaymentsController < ApplicationController
 # def success
  #  order = Order.find(params[:order_id])
   # if order.payment_status != "paid"
   #   order.update(payment_status: "paid", status: "in_progress")
    #end
    #redirect_to my_orders_path, notice: "Payment successful for Order ##{order.id}"
#  end

  def cancel
    redirect_to my_orders_path, alert: "Payment was cancelled."
  end
end
