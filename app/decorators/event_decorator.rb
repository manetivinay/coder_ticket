class EventDecorator < Draper::Decorator
  delegate_all

  def short_description
    object.description.truncate(160, omission: '...')
  end

  def start_at
    FormatUtils.date_to_string(object.start_at)
  end

  def venue_name
    object.venue ? object.venue.name : ''
  end

  def venue_address
    object.venue ? object.venue.address : ''
  end

  def image
    object.local_image_url ? object.local_image_url : object.image
  end

  def fullname
    prefix = object.is_hot ? 'HOT: ' : ''
    prefix + object.name
  end

  def checked
    object.is_hot ? 'checked' : ''
  end

  def selected_region(region_id)
    'selected' if object.venue && object.venue.region_id == region_id
  end

  def selected_category(category_id)
    'selected' if object.category_id == category_id
  end

  def end_at
    FormatUtils.date_to_string(object.end_at)
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
