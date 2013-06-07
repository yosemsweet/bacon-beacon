module Clickbank
	module IPN		
		def from_clickbank(params)
			payload = {}
			begin
				payload[:full_name] = params[:ccustfullname]
				payload[:email] = params[:ccustemail]
				payload[:amount] = params[:corderamount].to_i
				payload[:currency] = params[:ccurrency]
				payload[:transaction_type] = self.transaction_type params[:ctransaction]
				payload[:receipt] = params[:ctransreceipt]
				payload[:address] = Address.new({country_code: params[:ccustcc], region: params[:ccuststate], city: params[:ccustcity], postal_code: params[:ccustzip], street: [params[:ccustaddr1],params[:ccustaddr2]].join('\n')})
			rescue Exception => e
				raise "Invalid Params" + e.message
			end
			return Payload.new(payload)
		end
		
		def transaction_type(type)
			type = :test
		end
	end
end

Payload.extend Clickbank::IPN

