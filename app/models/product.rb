class Product
	attr_reader :id, :description, :vendor
	
	def initialize(values = {})
		@id = values[:id]
		@description = values[:description]
		@vendor = values[:vendor]
	end
	
	def valid?
		@id.present? && !@description.nil? && @vendor.present?
	end
	
	def to_h
		{
			id: self.id,
			description: self.description,
			vendor: self.vendor
		}
	end
end