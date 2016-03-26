require 'spec_helper'

describe EventDecorator do
  before(:each) do
    @event = Event.new(
        start_at: Time.zone.local(2016, 7, 20),
        end_at: Time.zone.local(2016, 8, 20),
        description: 'a' * 1000,
    ).decorate
  end

  context 'format' do
    it 'should format start time' do
      expect(@event.start_at).to eq('20 July, 2016')
    end

    it 'should format end time' do
      expect(@event.end_at).to eq('20 August, 2016')
    end

    it 'should return short description' do
      expect(@event.short_description).to eq('a' * 197 + '...')
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
