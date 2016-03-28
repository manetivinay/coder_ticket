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

  describe '#update' do
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
end
