class AccountsController < ApplicationController
	
	respond_to :html
	protect_from_forgery :except => :track
	
	def track
		respond_to do |format|
			payload = Payload.from_clickbank(params)
    	format.html do
				if payload.valid?
					PayloadWorker.perform_async(payload.to_h)
					head :ok
				else
					head :bad_request
				end
			end
    end
		
	end
end
