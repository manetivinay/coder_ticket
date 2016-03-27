class CreateOrderService < BaseService
  def create
    start_transaction
    @errors
  end

  private
  def start_transaction
    ActiveRecord::Base.transaction do
      prepare_data
      create_order
      create_order_detail
      send_email
    end
  end

  def prepare_data
    @ticket_types = TicketType.where('id IN (?)', @params[:ticket_ids])
                        .order('created_at asc')
  end

  def create_order
    @order = Order.new(order_params)
    save_in_transaction(@order)
  end

  def create_order_detail
    @params[:ticket_quantities]
        .map { |quantity| quantity.to_i }
        .zip(@ticket_types)
        .select { |quantity, _| quantity > 0 }
        .each { |quantity, ticket_type|
          create_ticket_order(quantity, ticket_type)
          decrease_quantity(quantity, ticket_type)
        }
  end

  def create_ticket_order(quantity, ticket_type)
    @order.ticket_orders.create(ticket_type: ticket_type, quantity: quantity)
  end

  def decrease_quantity(quantity, ticket_type)
    unless ticket_type.decrement(:max_quantity, quantity).save
      @errors << "Sorry, there are no more ticket for #{ticket_type.name}, please restart the page"
      raise ActiveRecord::Rollback
    end
  end

  def send_email
    OrderMailer.thank_you(@order.email, @order.id).deliver_later
  end

  def order_params
    @params.require(:order).permit(:username, :phone, :email, :total_money)
  end
end