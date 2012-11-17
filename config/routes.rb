Nvoice::Application.routes.draw do

	resources :invoices do
		member do
			get :items
			get :toggle_paid
		end
	end
	resources :items
	resources :sessions
	resources :users

	root to: 'users#show'

	# Sessions
	match '/sign-in' => 'sessions#new', as: :signin
	match '/sign-out' => 'sessions#destroy', as: :signout
end