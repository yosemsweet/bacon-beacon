class Address < Struct.new(:country_code, :region, :postal_code, :city, :street)
	def initialize(values = {})
		self.country_code = values[:country_code]
		if values.has_key? :state
			self.state = values[:state]
		else
			self.region = values[:region]
		end
		self.postal_code = values[:postal_code]
		self.city = values[:city]
		self.street = values[:street]
	end
	
	def state
		self.region
	end
	
	def state=(s)
		self.region = s
	end
	
	def to_h
		{
			country_code: self.country_code, 
			region: self.region, 
			postal_code: self.postal_code, 
			city: self.city, 
			street: self.street
		}
	end
end