class OrderMailer < ApplicationMailer
  def thank_you(email, order_id)
    @order = Order.find(order_id)
    mail(to: email, subject: 'Thank you')
  end
end
