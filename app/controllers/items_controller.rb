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
			if @item.save!
				@item.amount = @item.hours * @item.rate
				@item.save
				respond_to do |format|
					format.html {
						flash[:success] = 'Item created'
						redirect_to items_invoice_path(@invoice)
					}
					format.js {
						@item = Item.new
						@items = @invoice.items.order('date DESC')
					}
				end
			else
				@title = "Invoice #{@invoice.id}"
				@items = @invoice.items.order('date DESC')
				@user = @invoice.user
				@client = @invoice.client
				@user_number = @user.phone_number
				@client_number = @client.phone_number
				render 'invoices/items'
			end
		end
	end

	def edit
		@title = 'Edit Item'
		@item = Item.find(params[:id])
		@invoice = @item.invoice
		if @invoice.paid?
			flash[:notice] = 'You cannot edit items for paid invoices'
			redirect_to @invoice
		end
	end

	def update
		@item = Item.find(params[:id])
		@invoice = @item.invoice
		if @item.update_attributes(params[:item])
			flash[:success] = 'Item updated'
			redirect_to items_invoice_path(@invoice)
		else
			@title = 'Edit Item'
			render 'edit'
		end
	end

	def destroy
		item = Item.find(params[:id])
		item_id = item.id
		invoice = item.invoice
		if invoice.paid?
			flash[:notice] = \
				'You cannot delete items for paid invoices'
			redirect_to items_invoice_path(invoice)
		else
			item.destroy
			respond_to do |format|
				format.html {
					flash[:success] = 'Item deleted'
					redirect_to items_invoice_path(invoice)
				}
				format.js {
					@item_id = item_id
					@invoice = invoice
				}
			end
		end
	end
end