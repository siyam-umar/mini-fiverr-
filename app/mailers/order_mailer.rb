class OrderMailer < ApplicationMailer
  def order_accepted(order)
    @order = order
    mail(to: @order.user.email, subject: "Your Order Has Been Accepted")
  end

  def order_rejected(order)
    @order = order
    mail(to: @order.user.email, subject: "Your Order Has Been Rejected")
  end
end

