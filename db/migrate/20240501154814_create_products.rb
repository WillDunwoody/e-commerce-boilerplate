class CreateProducts < ActiveRecord::Migration[7.1]
  def change
    create_table :products do |t|
      t.string :name
      t.text :description
      t.float :price, default: 0.0
      t.integer :stock_quantity, default: 0
      t.string :image_url

      t.timestamps
    end
  end
end
