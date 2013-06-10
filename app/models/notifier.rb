class Notifier
	attr_reader :payload
	
	def initialize(payload)
		@payload = payload
	end
	
	def notify
		KM.init('a22aa855ed62549d717886bca603e402cba337ac')
		if self.payload.email.present?
			KM.identify(self.payload.email)
			KM.alias(self.payload.email, self.payload.receipt)
		else
			receipt_part = self.payload.receipt.split('-').first
			KM.identify(receipt_part)
			KM.alias(receipt_part, self.payload.receipt) unless self.payload.receipt == receipt_part
		end
		
		case self.payload.transaction_type
		when :bill
			properties = {
				'Billing Amount' => (self.payload.amount/100.0).round(2), 
				'Currency' => self.payload.currency, 
				'Receipt' => self.payload.receipt 
			}
			if self.payload.product.valid?
				properties["Product ID"] = self.payload.product.id
				properties["Product Name"] = self.payload.product.description
			end
			properties["Product Category"] = self.payload.product.vendor if self.payload.product.vendor
			
			KM.record('Billed', properties)
		when :refund
			properties = {
				'Billing Amount' => (self.payload.amount/100.0).round(2).abs * -1, 
				'Currency' => self.payload.currency, 
				'Receipt' => self.payload.receipt 
			}
			if self.payload.product.valid?
				properties["Product ID"] = self.payload.product.id
				properties["Product Name"] = self.payload.product.description
			end
			properties["Product Category"] = self.payload.product.vendor if self.payload.product.vendor
			
			KM.record('Refunded', properties)
		when :cancel
			properties = { 'Receipt' => self.payload.receipt }
			if self.payload.product.valid?
				properties["Product ID"] = self.payload.product.id
				properties["Product Name"] = self.payload.product.description
			end
			properties["Product Category"] = self.payload.product.vendor if self.payload.product.vendor
			KM.record('Canceled', properties)
		end
	end
end