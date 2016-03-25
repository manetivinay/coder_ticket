class CreateTicketOrders < ActiveRecord::Migration
  def change
    create_table :ticket_orders do |t|
      t.references :ticket_type, index: true, foreign_key: true
      t.references :order, index: true, foreign_key: true
      t.integer :quantity

      t.timestamps null: false
    end
  end
end
