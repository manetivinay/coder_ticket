module EventsHelper
  def event_link(event, is_edit)
    is_edit ? edit_event_path(event) : event
  end
end