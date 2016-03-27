class BaseService
  def initialize(params)
    @params = params
    @errors = []
  end

  def save_in_transaction(object)
    unless object.save
      @errors += object.errors.full_messages
      raise ActiveRecord::Rollback
    end
  end

  def update_in_transaction(object, params)
    unless object.update_attributes(params)
      @errors += object.errors.full_messages
      raise ActiveRecord::Rollback
    end
  end
end