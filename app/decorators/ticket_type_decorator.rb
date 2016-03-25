class TicketTypeDecorator < Draper::Decorator
  delegate_all

  def price_vnd
    FormatUtils.format_price(price)
  end

  def max_quantity
    object.max_quantity < 10 ? object.max_quantity : 10
  end
end
