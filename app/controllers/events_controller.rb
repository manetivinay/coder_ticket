# == Schema Information
#
# Table name: events
#
#  id          :integer          not null, primary key
#  start_at    :datetime
#  end_at      :datetime
#  venue_id    :integer
#  image       :string
#  description :text
#  category_id :integer
#  name        :string
#  created_at  :datetime         not null
#  updated_at  :datetime         not null
#

class EventsController < ApplicationController
  before_action :get_event, only: [:show]

  def index
    @events = Event.upcoming.preload(:venue, :category).decorate
  end

  def search
    @events = Event.search(params[:key_word]).preload(:venue, :category).decorate
    render :index
  end

  def show
    @ticket_types = @event.ticket_types.decorate
  end

  def new
  end

  def create
  end

  def edit
  end

  def update
  end

  def destroy
  end

  private
  def get_event
    @event = Event.find(params[:id]).decorate
    unless @event.upcoming?
      flash[:alert] = 'This event has passed'
      redirect_to root_path
    end
  end
end
