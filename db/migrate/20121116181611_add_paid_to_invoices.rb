class AddPaidToInvoices < ActiveRecord::Migration
  def change
  	change_column :users, :phone, :bigint

    add_column :invoices, :paid, :boolean

    add_index :invoices, :paid
  end
end