class RemovePhoneFromUsers < ActiveRecord::Migration
  def change
  	remove_column :users, :phone
  	add_column :users, :phone, :bigint
  end
end
