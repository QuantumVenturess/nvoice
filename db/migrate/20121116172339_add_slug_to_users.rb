class AddSlugToUsers < ActiveRecord::Migration
  def change
    add_column :users, :encrypted_password, :string
    add_column :users, :salt, :string
    add_column :users, :slug, :string

    add_index :users, :slug, unique: true
  end
end
