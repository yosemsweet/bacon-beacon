class Notifier
	attr_reader :payload
	
	def initialize(payload)
		@payload = payload
	end
	
	def notify
		KM.init('a22aa855ed62549d717886bca603e402cba337ac')
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
				'Billing Amount' => -amount.to_s, 
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