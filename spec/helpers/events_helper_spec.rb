require 'spec_helper'

describe EventsHelper, type: :helper do
  before(:each) do
    @event = DataSupport.create_event
  end

  describe '#event_link' do
    it 'should returns edit_event_path' do
      expect(helper.event_link(@event, true)).to eq("/events/#{@event.id}/edit")
    end

    it 'should returns event_path' do
      expect(helper.event_link(@event, false)).to eq("/events/#{@event.id}")
    end

    it 'should returns event_path' do
      expect(helper.event_link(@event)).to eq("/events/#{@event.id}")
    end
  end
end