class AddLocalImageToEvent < ActiveRecord::Migration
  def change
    add_column :events, :local_image, :string
  end
end
