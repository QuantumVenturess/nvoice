class SessionsController < ApplicationController

	def new
		if signed_in?
			redirect_to current_user
		else
			@title = "Sign in"
		end
	end

	def create
		redirect_to root_path if signed_in?
		params[:session][:email] = params[:session][:email].downcase
		user = User.authenticate(params[:session][:email], 
			params[:session][:password])
		if user
			sign_in_temp user
			redirect_back_or user
		else
			@title = "Sign in"
			flash.now[:error] = \
				"The email or password you have entered is invalid."
			render 'new'
		end
	end

	def destroy
		sign_out
		redirect_to signin_path
	end
end