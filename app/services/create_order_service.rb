class CreateOrderService
  def initialize(params)
    @params = params
  end

  def create
    @order = Order.new(order_params)
    create_ticket_orders if @order.save
    @order
  end

  private
  def create_ticket_orders
    @params[:ticket_ids].zip(@params[:ticket_quantities]).each do |id, quantity|
      @order.ticket_orders.create(ticket_type_id: id, quantity: quantity)
    end
  end

  def order_params
    @params.require(:order).permit(:username, :phone, :email, :total_money)
  end
end