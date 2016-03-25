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
  def index
    @events = Event.upcoming.decorate
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
end
