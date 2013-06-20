class Notifier
	attr_reader :payload
	attr_reader :account
	
	def initialize(account, payload)
		@payload = payload
		@account = account
	end
	
	def notify
		km_api = account.km_api_key || 'a22aa855ed62549d717886bca603e402cba337ac'
		KM.init(km_api)
		if self.payload.email.present?
			KM.identify(self.payload.email)
			KM.alias(self.payload.email, self.payload.receipt.to_s)
		else
			KM.identify(self.payload.receipt.parent.to_s)
			KM.alias(self.payload.receipt.parent.to_s, self.payload.receipt.to_s) if self.payload.receipt.sub_receipt?
		end
		
		case self.payload.transaction_type
		when :bill
			amount = self.payload.amount.exchange_to("USD")
			properties = {
				'Billing Amount' => amount.to_s, 
				'Currency' => amount.currency.iso_code, 
				'Receipt' => self.payload.receipt.to_s 
			}
			if self.payload.product.valid?
				properties["Product ID"] = self.payload.product.id
				properties["Product Name"] = self.payload.product.description
			end
			properties["Product Category"] = self.payload.product.vendor if self.payload.product.vendor
			KM.record('Billed', properties)
		when :refund
			amount = self.payload.amount.exchange_to("USD")
			properties = {
				'Billing Amount' => amount.to_s, 
				'Currency' => amount.currency.iso_code,
				'Receipt' => self.payload.receipt.to_s
			}
			if self.payload.product.valid?
				properties["Product ID"] = self.payload.product.id
				properties["Product Name"] = self.payload.product.description
			end
			properties["Product Category"] = self.payload.product.vendor if self.payload.product.vendor
			
			KM.record('Refunded', properties)
		when :cancel
			properties = { 'Receipt' => self.payload.receipt.to_s }
			if self.payload.product.valid?
				properties["Product ID"] = self.payload.product.id
				properties["Product Name"] = self.payload.product.description
			end
			properties["Product Category"] = self.payload.product.vendor if self.payload.product.vendor
			KM.record('Canceled', properties)
		end
	end
end