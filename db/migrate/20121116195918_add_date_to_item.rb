class AddDateToItem < ActiveRecord::Migration
  def change
    add_column :items, :date, :datetime
    add_index :items, :date
  end
end
