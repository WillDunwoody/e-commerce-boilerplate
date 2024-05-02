class CreateOrders < ActiveRecord::Migration[7.1]
  def change
    create_table :orders do |t|
      t.references :user, null: false, foreign_key: true
      t.integer :total_price, default: 0
      t.integer :status, default: 0
      t.integer :payment_method

      t.timestamps
    end
  end
end
