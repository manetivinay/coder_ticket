include FactoryGirl::Syntax::Methods

class DataSupport
  def self.create_events
    category = create(:category)
    venue = create(:venue)
    user = create(:user)
    events = [:event1, :event2, :event3]
    events.map do |e|
      create(e, category: category, venue: venue, user: user)
    end
  end

  def self.create_event
    category = create(:category)
    venue = create(:venue)
    user = create(:user)
    create(:event1, category: category, venue: venue, user: user)
  end

  def self.create_extra_event
    create(:event4, category: create(:category, name: 'Âm nhạc'),
           venue: create(:venue, region: Region.create(name: 'Da Nang')), user: create(:user, email: 'xxx@xxx.com'))
  end

  def self.create_ticket_types(event)
    tickets = [:ticket1, :ticket2, :ticket3]
    tickets.map do |t|
      create(t, event: event)
    end
  end

  def self.create_sold_out_tickets(event)
    tickets = [:ticket1, :ticket2, :ticket3]
    tickets.map do |t|
      create(t, event: event, max_quantity: 0)
    end
  end
end