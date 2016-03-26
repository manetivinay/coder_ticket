class TicketTypeDecorator < Draper::Decorator
  delegate_all

  def price_vnd
    FormatUtils.format_price(price)
  end

  def available_quantity
    result = (min_quantity..max_quantity).to_a
    result.insert(0, 0) if min_quantity > 0
    result
  end

  def max_quantity
    object.max_quantity < 10 ? object.max_quantity : 10
  end

  def min_quantity
    able_to_provide_min? ? object.minimum_quantity : 0
  end

  def name
    object.name + (sold_out? ? ' (sold out)' : '')
  end

  def css_class
    sold_out? ? 'sold-out' : ''
  end

  private
  def able_to_provide_min?
    object.max_quantity >= object.minimum_quantity
  end

  def sold_out?
    max_quantity == 0
  end
end
