BaconBeacon::Application.routes.draw do
	root :to => 'high_voltage/pages#show', :id => 'home'
	
  devise_for :admin_users, ActiveAdmin::Devise.config
  ActiveAdmin.routes(self)

	resources :accounts do
		member do
			post 'track'
		end
	end
end
