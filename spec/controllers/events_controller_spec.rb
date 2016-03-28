# == Schema Information
#
# Table name: events
#
#  id           :integer          not null, primary key
#  start_at     :datetime
#  end_at       :datetime
#  venue_id     :integer
#  image        :string
#  description  :text
#  category_id  :integer
#  name         :string
#  created_at   :datetime         not null
#  updated_at   :datetime         not null
#  is_hot       :boolean          default(FALSE)
#  is_published :boolean          default(FALSE)
#  user_id      :integer
#  local_image  :string
#

require 'rails_helper'

RSpec.describe EventsController, type: :controller do
  before(:each) do
    @user = create(:user, email: 'xxx@xxx.com')
    @events = DataSupport.create_events
    @owner = User.second
    @event = @events[0]
    @ticket_types = DataSupport.create_ticket_types(@event)
  end

  describe '#index' do
    it 'upcoming should be decorated' do
      get :index
      expect(assigns(:events)).to be_decorated
    end
  end

  describe '#search' do
    before(:each) do
      get :search, key_word: 'a'
    end

    it 'search should be decorated' do
      expect(assigns(:events)).to be_decorated
    end

    it 'should search' do
      result = assigns(:events).map { |event| event.name }
      expect(result).to eq %w(abc)
    end

    it 'should render index' do
      expect(response).to render_template :index
    end
  end

  describe '#new' do
    context 'login' do
      before(:each) do
        session[:user_id] = @user.id
        get :new
      end

      it 'should be decorated' do
        expect(assigns(:event)).to be_decorated
      end

      it 'should render new' do
        expect(response).to render_template :new
      end
    end

    context 'not login' do
      it 'should redirect to root' do
        get :new
        expect(response).to redirect_to root_path
      end
    end
  end

  describe '#show' do
    context 'is upcoming event' do
      before(:each) do
        @event.update_attributes(start_at: Time.now + 1.day)
        get :show, id: @event.id
      end

      it 'should be decorated' do
        expect(assigns(:event)).to be_decorated
      end

      it 'should render show' do
        expect(response).to render_template :show
      end
    end

    context 'is not upcoming event' do
      before(:each) do
        @event.update_attributes(start_at: Time.now - 1.day)
        get :show, id: @event.id
      end

      it 'should redirect to root' do
        expect(response).to redirect_to root_path
      end

      it 'should show flash' do
        expect(flash[:alert]).to eq('This event has passed')
      end
    end
  end

  describe '#mine' do
    context 'not login' do
      it 'should redirect to root' do
        get :mine
        expect(response).to redirect_to root_path
      end
    end

    context 'login' do
      before(:each) do
        session[:user_id] = @owner.id
        get :mine
      end

      it 'should decorate data' do
        expect(assigns(:events)).to be_decorated
      end

      it 'should order desc' do
        expect(assigns(:events).map { |e| e.name }).to eq(%w(bbbbb aba abc))
      end
    end
  end

  describe '#publish' do
    it 'should not alow publish' do
      session[:user_id] = @user.id
      get :publish, id: @event.id
      expect(flash[:alert]).to eq('You have no permission')
      expect(response).to redirect_to root_path
    end

    it 'should alow publish' do
      session[:user_id] = @owner.id
      get :publish, id: @event.id
      @event.reload
      expect(@event.is_published).to eq(true)
      expect(response).to redirect_to event_path(@event)
    end
  end

  describe '#edit' do
    before(:each) do
      session[:user_id] = @owner.id
      get :edit, id: @event.id
    end

    it 'should decorate data' do
      expect(assigns(:ticket_types)).to be_decorated
    end

    it 'should render edit' do
      expect(response).to render_template :edit
    end

    it 'should order ticket_types' do
      expect(assigns(:ticket_types).map { |t| t.name }).to eq(%w(vip normal super))
    end
  end

  describe '#create' do
    context 'mock' do
      before(:each) do
        session[:user_id] = @owner.id
        allow_any_instance_of(CreateEventService).to receive(:execute).and_return(
            {errors: [], event: @event}
        )
        post :create, format: :js
      end

      it 'should get errors' do
        expect(assigns(:errors)).to eq([])
      end

      it 'should get event' do
        expect(assigns(:event)).to eq(@event)
      end
    end

    context 'integration' do
      before(:each) do
        session[:user_id] = @user.id
        allow_any_instance_of(Event).to receive(:local_image_url).and_return('link')
      end

      context 'error params' do
        it 'should return venue errors' do
          post :create, {
              format: :js,
              venue: attributes_for(:invalid_venue)
          }
          expect(assigns(:errors)).to include("Region can't be blank")
        end

        it 'should return event errors' do
          post :create, {
              format: :js,
              venue: attributes_for(:valid_venue),
              event: attributes_for(:invalid_event)
          }
          expect(assigns(:errors)).to include("Name can't be blank")
        end

        it 'should have at least one ticket types' do
          post :create, {
              format: :js,
              venue: attributes_for(:valid_venue),
              event: attributes_for(:valid_event, category_id: Category.first.id)
          }
          expect(assigns(:errors)).to include("Event must have at least one ticket type")
        end

        it 'should have valid time' do
          post :create, {
              format: :js,
              venue: attributes_for(:valid_venue),
              event: attributes_for(:invalid_time_event, category_id: Category.first.id)
          }
          expect(assigns(:errors)).to include("Start date must smaller than end date")
        end

        it 'should have valid time' do
          post :create, {
              format: :js,
              venue: attributes_for(:valid_venue),
              event: attributes_for(:invalid_time_event_2, category_id: Category.first.id)
          }
          expect(assigns(:errors)).to include("Start date must larger than now")
        end
      end

      context 'create success' do
        before(:each) do
          post :create, {
              format: :js,
              venue: attributes_for(:valid_venue),
              event: attributes_for(:valid_event, category_id: Category.first.id),
              ticket_types: [attributes_for(:ticket1), attributes_for(:ticket2)]
          }
        end

        it 'should create event success' do
          expect(Event.count).to eq(4)
        end

        it 'should have no error' do
          expect(assigns(:errors)).to be_blank
        end
      end
    end
  end

  describe '#update' do
    context 'mock' do
      before(:each) do
        session[:user_id] = @owner.id
        allow_any_instance_of(UpdateEventService).to receive(:execute).and_return(
            {errors: [], event: @event}
        )
        post :update, id: @event.id, format: :js
      end

      it 'should get errors' do
        expect(assigns(:errors)).to eq([])
      end

      it 'should get event' do
        expect(assigns(:event)).to eq(@event)
      end
    end

    context 'integration' do
      before(:each) do
        session[:user_id] = @owner.id
        allow_any_instance_of(Event).to receive(:local_image_url).and_return('link')
      end

      context 'update errors' do
        it 'should include event errors' do
          post :update, {
              id: @event.id,
              format: :js,
              venue: attributes_for(:valid_venue),
              event: attributes_for(:invalid_event_2, category_id: Category.first.id),
          }
          expect(assigns(:errors)).to include("Name can't be blank")
        end
      end

      context 'update success' do
        before(:each) do
          post :update, {
              id: @event.id,
              format: :js,
              venue: attributes_for(:valid_venue),
              event: attributes_for(:valid_event, category_id: Category.first.id),
              ticket_types: [attributes_for(:ticket1), attributes_for(:ticket2)]
          }
          @event.reload
        end

        it 'should have no error' do
          expect(assigns(:errors)).to be_blank
        end

        it 'should update event' do
          expect(@event.name).to eq('name')
          expect(@event.ticket_types.count).to eq(2)
        end
      end
    end
  end
end
