class OrdersController < ApplicationController
  def new
    @event = Event.find(params[:event_id])
    @ticket_types = @event.ticket_types.decorate
  end

  def create
    @order = CreateOrderService.new(params).create
    flash[:notice] = 'We have sent email to you' if @order.persisted?
    respond_to :js
  end
end
