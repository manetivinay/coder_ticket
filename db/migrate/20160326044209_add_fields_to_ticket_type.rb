class AddFieldsToTicketType < ActiveRecord::Migration
  def change
    add_column :ticket_types, :minimum_quantity, :integer, default: 1
  end
end
