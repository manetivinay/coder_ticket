class CreateOrders < ActiveRecord::Migration
  def change
    create_table :orders do |t|
      t.decimal :total_money
      t.string :username
      t.string :email
      t.string :phone

      t.timestamps null: false
    end
  end
end
