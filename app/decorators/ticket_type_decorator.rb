class TicketTypeDecorator < Draper::Decorator
  delegate_all

  def price_vnd
    FormatUtils.format_price(price)
  end

  def max_quantity
    object.max_quantity < 10 ? object.max_quantity : 10
  end

  def name
    object.name + (sold_out? ? ' (sold out)' : '')
  end

  def css_class
    sold_out? ? 'sold-out' : ''
  end

  private
  def sold_out?
    max_quantity == 0
  end
end
