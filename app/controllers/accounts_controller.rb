class AccountsController < ApplicationController
	
	respond_to :html
	protect_from_forgery :except => :track
	
	def track
		respond_to do |format|
    	format.html do				
				render text: "Okay!"
			end
    end
		
	end
end
