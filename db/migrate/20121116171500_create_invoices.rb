class CreateInvoices < ActiveRecord::Migration
  def change
    create_table :invoices do |t|
      t.integer :user_id
      t.integer :client_id

      t.timestamps
    end
    add_index :invoices, :user_id
    add_index :invoices, :client_id
  end
end
