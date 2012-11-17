class Item < ActiveRecord::Base

	attr_accessible :date,
					:details,
					:hours,
					:rate,
					:amount,
					:invoice_id

	belongs_to :invoice
	belongs_to :user

	validates_presence_of :date
	validates_presence_of :details
	validates_presence_of :hours
	validates_presence_of :rate
end