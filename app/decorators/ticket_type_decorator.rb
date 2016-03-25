class TicketTypeDecorator < Draper::Decorator
  delegate_all

  def price_vnd
    FormatUtils.format_price(price)
  end
end
