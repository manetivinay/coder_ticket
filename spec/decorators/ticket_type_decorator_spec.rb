require 'spec_helper'

describe TicketTypeDecorator do
  let(:ticket_type) { build(:ticket1).decorate }

  describe '#price_vnd' do
    it 'should format price' do
      expect(ticket_type.price_vnd).to eq('100.000 VND')
    end
  end

  describe '#max_quantity' do
    it 'should return right max quantity' do
      expect(ticket_type.max_quantity).to eq(10)
    end

    it 'should return right max quantity' do
      ticket_type.object.max_quantity = 5
      expect(ticket_type.max_quantity).to eq(5)
    end


    it 'should return right max quantity' do
      ticket_type.object.max_quantity = 10
      expect(ticket_type.max_quantity).to eq(10)
    end
  end

  describe '#name' do
    it 'should return right name' do
      expect(ticket_type.name).to eq('vip')
    end

    it 'should return sold out name' do
      ticket_type.object.max_quantity = 0
      expect(ticket_type.name).to eq('vip (sold out)')
    end
  end

  describe '#css_class' do
    it 'should return right css_class' do
      expect(ticket_type.css_class).to eq('')
    end

    it 'should return sold out css_class' do
      ticket_type.object.max_quantity = 0
      expect(ticket_type.css_class).to eq('sold-out')
    end
  end
end
