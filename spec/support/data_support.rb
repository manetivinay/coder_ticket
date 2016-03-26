include FactoryGirl::Syntax::Methods

class DataSupport
  def self.create_events
    category = create(:category)
    venue = create(:venue)
    events = [:event1, :event2, :event3]
    events.each do |e|
      create(e, category: category, venue: venue)
    end
  end
end