class InvoicesController < ApplicationController
	before_filter :authenticate
	before_filter :admin_user, except: :show

	# Correct user
	def show
		@invoice = Invoice.find(params[:id])
		@title = "Invoice #{@invoice.id}"
		@items = @invoice.items.order('date ASC')
		@user = @invoice.user
		@client = @invoice.client
		@user_number = @user.phone_number
		@client_number = @client.phone_number
		if !current_user.admin? && current_user != @invoice.client
			redirect_to current_user
		end
	end

	# Admin user
	def index
		@title = 'Bills'
		@invoices = Invoice.order('created_at DESC')
	end

	def new
		@title = 'New Bill'
		@invoice = Invoice.new
		@clients = User.where("client = ?", true).order(:name).collect { |u| 
								[u.name, u.id] }
	end

	def create
		@invoice = Invoice.new
		@invoice.user_id = current_user
		client = User.where('id = ? AND client = ?', 
			params[:invoice][:client_id], true)
		if client.empty?
			@title = 'New Bill'
			@clients = User.where("client = ?", 
				true).order(:name).collect { |u| [u.name, u.id] }
			flash.now[:error] = 'You must select a valid client'
			render 'new'
		else
			@invoice.client_id = params[:invoice][:client_id]
			@invoice.paid = false
			@invoice.save
			flash[:success] = 'Bill created'
			redirect_to items_invoice_path(@invoice)
		end
	end

	def destroy
		invoice = Invoice.find(params[:id])
		if invoice.paid?
			flash[:notice] = 'You cannot delete a paid invoice'
			redirect_to items_invoice_path(invoice)
		elsif invoice.items
			flash[:notice] = 'You cannot delete an invoice with items'
			redirect_to items_invoice_path(invoice)
		else
			invoice.destroy
			flash[:success] = 'Invoice deleted'
			redirect_to invoices_path
		end
	end

	def items
		@invoice = Invoice.find(params[:id])
		if @invoice.paid?
			flash[:notice] = 'You cannot edit an invoice that has been paid'
			redirect_to @invoice
		else
			@title = "Invoice #{@invoice.id}"
			@item = Item.new
			@items = @invoice.items.order('date DESC')
			@user = @invoice.user
			@client = @invoice.client
			@user_number = @user.phone_number
			@client_number = @client.phone_number
		end
	end

	def toggle_paid
		invoice = Invoice.find(params[:id])
		if invoice.paid?
			invoice.paid = false
		else
			invoice.paid = true
		end
		invoice.save
		respond_to do |format|
			format.html {
				redirect_to invoices_path
			}
			format.js {
				@invoice = invoice
			}
		end
	end
end