class BaseEventService < BaseService
  def initialize(params, current_user)
    super(params)
    @current_user = current_user
  end

  def execute
    start_transaction
    {errors: @errors, event: @event}
  end

  protected
  def start_transaction
    raise NotImplementedError.new("You must implement")
  end

  def create_ticket_types
    if @params[:ticket_types]
      @params[:ticket_types].each do |data|
        ticket_type = @event.ticket_types.build(ticket_type_params(data))
        save_in_transaction(ticket_type)
      end
    else
      @errors << 'Event must have at least one ticket type'
      raise ActiveRecord::Rollback
    end
  end

  def check_valid_date
    if @event.start_at >= @event.end_at
      @errors << 'Start date must smaller than end date'
      raise ActiveRecord::Rollback
    elsif @event.start_at < Time.now
      @errors << 'Start date must larger than now'
      raise ActiveRecord::Rollback
    end
  end

  def ticket_type_params(data)
    data.permit(:name, :price, :max_quantity, :minimum_quantity)
  end

  def venue_params
    @params.require(:venue).permit(:name, :address, :region_id)
  end

  def event_params
    @params.require(:event).permit(
        :name, :description, :local_image, :start_at, :end_at, :category_id, :is_hot
    )
  end
end