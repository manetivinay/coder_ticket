# == Schema Information
#
# Table name: orders
#
#  id          :integer          not null, primary key
#  total_money :decimal(, )
#  username    :string
#  email       :string
#  phone       :string
#  created_at  :datetime         not null
#  updated_at  :datetime         not null
#

require 'rails_helper'

RSpec.describe OrdersController, type: :controller do
  before(:each) do
    @event = DataSupport.create_event
  end

  describe '#new' do
    it 'event should be decorated' do
      get :new, event_id: @event.id
      expect(assigns(:event)).to be_decorated
    end

    context 'sold out' do
      it 'should redirect to event' do
        DataSupport.create_sold_out_tickets(@event)
        get :new, event_id: @event.id
        expect(response).to redirect_to @event
      end
    end

    context 'success' do
      before(:each) do
        @types = DataSupport.create_ticket_types(@event)
        get :new, event_id: @event.id
      end

      it 'should render new' do
        expect(response).to render_template :new
      end

      it 'should return ticket types' do
        expect(assigns(:ticket_types).map { |t| t.name })
            .to eq(%w(vip normal super))
      end

      it 'should decorate ticket types' do
        expect(assigns(:ticket_types)).to be_decorated
      end
    end
  end

  describe 'create' do
    context 'sold out' do
      it 'should redirect to event' do
        DataSupport.create_sold_out_tickets(@event)
        post :create, event_id: @event.id, format: :js
        expect(response).to redirect_to @event
      end
    end

    context 'available' do
      before(:each) do
        DataSupport.create_ticket_types(@event)
      end

      it 'should contain error' do
        allow_any_instance_of(CreateOrderService).to receive(:create).and_return(%w(error1 error2 error3))
        post :create, event_id: @event.id, format: :js
        expect(assigns(:errors)).to eq(%w(error1 error2 error3))
        expect(flash[:notice]).to be_blank
      end

      it 'should show flash' do
        allow_any_instance_of(CreateOrderService).to receive(:create).and_return([])
        post :create, event_id: @event.id, format: :js
        expect(flash[:notice]).to eq('We have sent email to you')
      end
    end
  end
end
