class CreateEvents < ActiveRecord::Migration
  def change
    create_table :events do |t|
      t.datetime :start_at
      t.datetime :end_at
      t.references :venue, index: true, foreign_key: true
      t.string :image
      t.text :description
      t.references :category, index: true, foreign_key: true
      t.string :name

      t.timestamps null: false
    end
  end
end
