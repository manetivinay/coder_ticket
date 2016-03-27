class CreateEventService < BaseEventService

  private
  def start_transaction
    ActiveRecord::Base.transaction do
      create_venue
      create_event
      create_ticket_types
    end
  end

  def create_venue
    @venue = Venue.new(venue_params)
    save_in_transaction(@venue)
  end

  def create_event
    @event = @current_user.events.new(event_params)
    @event.venue = @venue
    save_in_transaction(@event)
    check_valid_date
  end
end