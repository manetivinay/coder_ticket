class UpdateEventService < CreateEventService

  private
  def start_transaction
    ActiveRecord::Base.transaction do
      update_event
      update_venue
      create_ticket_types
    end
  end

  def update_venue
    @venue = @event.venue
    update_in_transaction(@venue, venue_params)
  end

  def update_event
    @event = Event.find(@params[:id])
    update_in_transaction(@event, event_params)
    check_valid_date
  end

  def create_ticket_types
    @event.ticket_types.destroy_all
    super
  end
end