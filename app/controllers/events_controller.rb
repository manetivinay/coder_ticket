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
#

class EventsController < ApplicationController
  before_action :require_login, only: [:new, :create, :edit, :update, :destroy, :mine]
  before_action :get_extra, only: [:new, :edit]
  before_action :get_event, only: [:show, :edit, :update]
  before_action :check_owner, only: [:edit, :update]

  def index
    @events = Event.upcoming.preload(:venue, :category).decorate
  end

  def search
    @events = Event.search(params[:key_word]).preload(:venue, :category).decorate
    render :index
  end

  def show
    if @event.upcoming?
      @ticket_types = @event.ticket_types.order('created_at asc').decorate
    else
      flash[:alert] = 'This event has passed'
      redirect_to root_path
    end
  end

  def mine
    @events = current_user.events.order('created_at asc').preload(:venue, :category).decorate
  end

  def new
    @event = Event.new.decorate
  end

  def create
    result = CreateEventService.new(params).create
    @errors, @event = result[:errors], result[:event]
    if @errors.empty?
      redirect_to edit_event_path(@event)
    else
      render :new
    end
  end

  def edit
  end

  def update
    result = UpdateEventService.new(params).create
    @errors, @event = result[:errors], result[:event]
    if @errors.empty?
      redirect_to edit_event_path(@event)
    else
      render :new
    end
  end

  private
  def check_owner
    if current_user != @event.user
      flash[:alert] = 'You have no permission'
      redirect_to root_path
    end
  end

  def get_event
    @event = Event.find(params[:id]).decorate
  end

  def get_extra
    @categories = Category.all
    @regions = Region.all
  end
end
