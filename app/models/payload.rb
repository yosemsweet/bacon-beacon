class Payload
	attr_reader :full_name, :email, :amount, :vendor_amount, :currency, :product, :time_stamp, :transaction_type, :receipt, :address
	
	def initialize(values = {})
		@full_name = values[:full_name]
		@email = values[:email]
		@amount = values[:amount]
		@vendor_amount = values[:vendor_amount]
		@currency = values[:currency]
		@product = values[:product]
		@time_stamp = values[:time_stamp]
		@transaction_type = values[:transaction_type]
		@receipt = values[:receipt]
		@address = values[:address]
	end
	
	def self.transaction_types
		@@transaction_types ||= [:test, :bill, :cancel, :refund, :no_funds].freeze
	end
end