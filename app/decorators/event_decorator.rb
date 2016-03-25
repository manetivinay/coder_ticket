class EventDecorator < Draper::Decorator
  delegate_all

  def short_description
    object.description.truncate(200, omission: '...')
  end

  def start_at
    object.start_at.strftime('%d/%m/%Y - %I:%M%p')
  end

  def check_out_disable
    sold_out? ? 'disabled' : ''
  end

  def check_out_title
    sold_out? ? 'sold out' : 'book now'
  end

  def sold_out?
    available_type_count == 0
  end

  private
  def available_type_count
    object.ticket_types.select { |type| type.max_quantity > 0 }.count
  end
end
