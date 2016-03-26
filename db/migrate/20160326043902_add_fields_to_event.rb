class AddFieldsToEvent < ActiveRecord::Migration
  def change
    add_column :events, :is_hot, :boolean, default: false
    add_column :events, :is_published, :boolean, default: false
  end
end
