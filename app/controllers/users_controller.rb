class UsersController < ApplicationController
	before_filter :authenticate
	before_filter :correct_user_admin_user, only: [:edit, :update, :show]
	before_filter :admin_user, except: [:edit, :update, :show]

	# Correct user
	def edit
		@title = 'Edit Profile'
		@user = User.find(params[:id])
		render 'new'
	end

	def update
		params[:user][:email] = params[:user][:email].downcase
		@user = User.find(params[:id])
		if @user.update_attributes(params[:user])
  			if params[:user][:password].length >= 2 && \
  					params[:user][:password_confirmation].length >= 2 && \
  					@user == current_user
  				flash[:success] = "Password changed. \
  					Please sign in with your new password."
				sign_out
				redirect_to signin_path
			else
				flash[:success] = "User profile has been updated"
		  		redirect_to @user
		  	end
  		else
  			@title = "Edit Profile"
  			render 'new'
  		end
	end

	def show
		@title = 'Invoices'
		@user = User.find(params[:id])
		@invoices = @user.invoices.order('created_at DESC')
		render 'invoices/index'
	end

	# Admin users
	def index
		@title = 'Clients'
		@users = User.where('client = ?', true).order('name ASC')
	end

	def new
		@title = 'New User'
		@user = User.new
	end

	def create
		params[:user][:email] = params[:user][:email].downcase
		params[:user][:name] = params[:user][:name].split(' ').map { 
			|word| word.capitalize }.join(' ')
		@user = User.new(params[:user])
		if @user.save
			@user.client = true
			@user.save
			flash[:success] = 'User created'
			redirect_to @user
		else
			@title = 'New User'
			render 'new'
		end
	end
end