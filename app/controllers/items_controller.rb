class ItemsController < ApplicationController
	before_filter :authenticate
	before_filter :admin_user

	def create
		@invoice = Invoice.find(params[:item][:invoice_id])
		if @invoice.paid?
			flash[:notice] = 'You cannot add items to a paid invoice'
			redirect_to items_invoice_path(@invoice)
		else
			@item = current_user.items.new(params[:item])
			if @item.save
				@item.amount = @item.hours * @item.rate
				@item.save
				flash[:success] = 'Item created'
				redirect_to items_invoice_path(@invoice)
			else
				@title = "Invoice #{@invoice.id}"
				@items = @invoice.items.order('date ASC')
				@user = @invoice.user
				@client = @invoice.client
				@user_number = @user.phone_number
				@client_number = @client.phone_number
				render 'invoices/items'
			end
		end
	end

	def destroy
		item = Item.find(params[:id])
		invoice = item.invoice
		if invoice.paid?
			flash[:notice] = \
				'You cannot delete items for paid invoices'
			redirect_to invoice
		else
			item.destroy
			flash[:success] = 'Item deleted'
			redirect_to invoice
		end
	end
end