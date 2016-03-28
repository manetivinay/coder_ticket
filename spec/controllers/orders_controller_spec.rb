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
        @ticket_types = DataSupport.create_ticket_types(@event)
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

    context 'integration with service' do
      before(:each) do
        mail = double(:mail)
        allow(mail).to receive(:deliver_later)
        allow_any_instance_of(OrderMailer).to receive(:thank_you).and_return(mail)
        @ticket_types = DataSupport.create_ticket_types(@event)
        @ticket_ids = @ticket_types.map { |t| t.id }
      end

      context 'error' do
        before(:each) do
          post :create, {
              event_id: @event.id,
              order: attributes_for(:invalid_order),
              ticket_ids: @ticket_ids, format: :js
          }
        end

        it 'should return errors order' do
          expect(assigns(:errors)).to include('Username can\'t be blank')
        end

        it 'should not create order' do
          expect(Order.count).to eq(0)
        end
      end

      context 'success' do
        before(:each) do
          post :create, {
              event_id: @event.id,
              ticket_quantities: [2, 0, 0],
              order: attributes_for(:order),
              ticket_ids: @ticket_ids, format: :js
          }
          @order = Order.first
        end

        it 'should create order' do
          expect(Order.count).to eq(1)
        end

        it 'should have right email' do
          expect(@order.email).to eq('nongdenchet@gmail.com')
        end

        it 'should have one ticket' do
          expect(@order.ticket_orders.count).to eq(1)
        end

        it 'should have 2 quantity' do
          expect(@order.ticket_orders.first.quantity).to eq(2)
        end

        it 'should buy vip' do
          expect(@order.ticket_orders.first.ticket_type.name).to eq('vip')
        end
      end

      context 'not enough ticket to buy' do
        before(:each) do
          post :create, {
              event_id: @event.id,
              ticket_quantities: [30, 0, 0],
              order: attributes_for(:order),
              ticket_ids: @ticket_ids, format: :js
          }
        end

        it 'should return errors order' do
          expect(assigns(:errors)).to include("Sorry, there are no more ticket for vip, please restart the page")
        end

        it 'should not create order' do
          expect(Order.count).to eq(0)
        end
      end
    end
  end
end
