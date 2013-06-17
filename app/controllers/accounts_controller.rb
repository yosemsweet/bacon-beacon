class AccountsController < ApplicationController
	
	respond_to :html
	protect_from_forgery :except => :track
	
	def track
		respond_to do |format|
			payload = Payload.from_clickbank(params)
			account_id = params[:id]
    	format.html do
				if payload.valid?
					PayloadWorker.perform_async(payload.to_h.merge account_id: account_id)
					head :ok
				else
					head :bad_request
				end
			end
    end
		
	end
end