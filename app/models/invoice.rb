class Invoice < ActiveRecord::Base

	belongs_to :user
	belongs_to :client, class_name: 'User'

	has_many :items, dependent: :destroy

	def total
		items = self.items
		self.items.map { |i| i.amount }.sum
	end
end