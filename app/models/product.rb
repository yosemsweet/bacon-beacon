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
end