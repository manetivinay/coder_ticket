class EventDecorator < Draper::Decorator
  delegate_all

  def description
    object.description.truncate(200, omission: '...')
  end
end
