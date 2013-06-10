require 'active_support/concern'

module Clickbank
	module IPN
		extend ActiveSupport::Concern
		
		module ClassMethods
			#TODO - The receipt number for a recurring billing is of the form RECEIPT-BXXX where XXX is the billing count. We need to identify the user by the original receipt number in KM and then alias all new receipts for that recurring billing product to the original receipt number.
			def from_clickbank(params)
				payload = {}
				begin
					payload[:full_name] = params[:ccustfullname]
					payload[:email] = params[:ccustemail]
					payload[:amount] = params[:corderamount].to_i
					payload[:currency] = params[:ccurrency]
					payload[:transaction_type] = self.transaction_type params[:ctransaction]
					payload[:receipt] = params[:ctransreceipt]
					payload[:product] = Product.new({id: params[:cproditem], description: params[:cprodtitle], vendor: params[:ctranspublisher]})
					payload[:address] = Address.new({country_code: params[:ccustcc], region: params[:ccuststate], city: params[:ccustcity], postal_code: params[:ccustzip], street: [params[:ccustaddr1],params[:ccustaddr2]].join('\n')})
				rescue Exception => e
					raise "Invalid Params" + e.message
				end
				return Payload.new(payload)
			end
		
			def transaction_type(type)
				case type
				when 'TEST'
					:test
				when 'SALE'
					:bill
				when 'BILL'
					:bill
				when 'RFND'
					:refund
				when 'CGBK'
					:refund
				when 'CANCEL-REBILL'
					:cancel
				when 'INSF'
					:no_funds
				when 'UNCANCEL-REBILL'
					:bill
				end
			end
		end
	end
end
