class CreateUsers < ActiveRecord::Migration
  def change
    create_table :users do |t|
      t.string :name
      t.string :email
      t.string :address
      t.string :city
      t.string :state
      t.integer :zip
      t.integer :phone
      t.boolean :admin
      t.boolean :client

      t.timestamps
    end
    add_index :users, :name, unique: true
    add_index :users, :email, unique: true
    add_index :users, :address
    add_index :users, :city
    add_index :users, :state
    add_index :users, :zip
    add_index :users, :phone
    add_index :users, :admin, default: false
    add_index :users, :client, default: true
  end
end
