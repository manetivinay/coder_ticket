require 'spec_helper'

describe EventDecorator do
  before(:each) do
    @event = Event.new(
        name: 'name',
        start_at: Time.zone.local(2016, 7, 20),
        end_at: Time.zone.local(2016, 8, 20),
        description: 'a' * 1000,
    ).decorate
  end

  describe '#fullname' do
    it 'should return hot' do
      @event.is_hot = true
      expect(@event.fullname).to eq('HOT: name')
    end

    it 'should return normal' do
      expect(@event.fullname).to eq('name')
    end
  end

  describe '#checked' do
    it 'should return checked' do
      @event.is_hot = true
      expect(@event.checked).to eq('checked')
    end

    it 'should return not checked' do
      expect(@event.checked).to eq('')
    end
  end

  describe '#selected_region' do
    it 'should return not selected_region' do
      expect(@event.selected_region(1)).to be_blank
    end

    it 'should return not selected_region' do
      @event.venue = Venue.new(region_id: 2)
      expect(@event.selected_region(1)).to be_blank
    end

    it 'should return not selected_region' do
      @event.venue = Venue.new(region_id: 1)
      expect(@event.selected_region(1)).to eq('selected')
    end
  end

  describe '#image' do
    it 'should return image' do
      allow(@event.object).to receive(:local_image_url).and_return('link')
      expect(@event.image).to eq('link')
    end

    it 'should return not empty' do
      @event.image = 'image'
      expect(@event.image).to eq('image')
    end
  end

  describe '#venue_name' do
    it 'should return venue_name' do
      @event.venue = Venue.new(name: 'name')
      expect(@event.venue_name).to eq('name')
    end

    it 'should return not empty' do
      expect(@event.venue_name).to eq('')
    end
  end

  describe '#venue_address' do
    it 'should return venue_address' do
      @event.venue = Venue.new(address: 'name')
      expect(@event.venue_address).to eq('name')
    end

    it 'should return not empty' do
      expect(@event.venue_address).to eq('')
    end
  end

  describe '#selected_category' do
    it 'should return not selected_category' do
      expect(@event.selected_category(1)).to be_blank
    end

    it 'should return not selected_category' do
      @event.category_id = 1
      expect(@event.selected_category(1)).to eq('selected')
    end
  end

  context 'format' do
    it 'should format start time' do
      expect(@event.start_at).to eq('20 July, 2016')
    end

    it 'should format end time' do
      expect(@event.end_at).to eq('20 August, 2016')
    end

    it 'should return short description' do
      expect(@event.short_description).to eq('a' * 157 + '...')
    end
  end

  context 'sold out' do
    before(:each) do
      allow(@event.object).to receive(:ticket_types).and_return([TicketType.new(max_quantity: 0)])
    end

    it 'should return true' do
      expect(@event.sold_out?).to eq(true)
    end

    it 'should disable check out' do
      expect(@event.check_out_disable).to eq('disabled')
    end

    it 'should return right title' do
      expect(@event.check_out_title).to eq('sold out')
    end
  end

  context 'available' do
    before(:each) do
      allow(@event.object).to receive(:ticket_types).and_return([TicketType.new(max_quantity: 20)])
    end

    it 'should return true' do
      expect(@event.sold_out?).to eq(false)
    end

    it 'should disable check out' do
      expect(@event.check_out_disable).to eq('')
    end

    it 'should return right title' do
      expect(@event.check_out_title).to eq('book now')
    end
  end
end
