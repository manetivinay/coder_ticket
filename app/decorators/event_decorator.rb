class EventDecorator < Draper::Decorator
  delegate_all

  def short_description
    object.description.truncate(200, omission: '...')
  end

  def start_at
    object.start_at.strftime('%d/%m/%Y - %I:%M%p')
  end
end
