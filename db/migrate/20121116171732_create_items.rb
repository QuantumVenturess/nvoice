class CreateItems < ActiveRecord::Migration
  def change
    create_table :items do |t|
      t.string :name
      t.text :details
      t.float :hours
      t.float :rate
      t.float :amount
      t.integer :invoice_id
      t.integer :user_id

      t.timestamps
    end
    add_index :items, :name
    add_index :items, :details
    add_index :items, :hours
    add_index :items, :rate
    add_index :items, :amount
    add_index :items, :invoice_id
    add_index :items, :user_id
  end
end
