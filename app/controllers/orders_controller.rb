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

class OrdersController < ApplicationController
  before_action :require_available

  def new
    @ticket_types = @event.ticket_types.order('created_at asc').decorate
  end

  def create
    @errors = CreateOrderService.new(params).create
    flash[:notice] = 'We have sent email to you' if @errors.empty?
    respond_to :js
  end

  private
  def require_available
    @event = Event.find(params[:event_id]).decorate
    if @event.sold_out?
      flash[:alert] = 'This event has been sold out'
      redirect_to @event
    end
  end
end
