require 'active_support/core_ext/hash/indifferent_access'
require 'clickbank/ipn'

class Payload
	include Clickbank::IPN
	
	attr_reader :full_name, :email, :amount, :vendor_amount, :currency, :product, :time_stamp, :transaction_type, :receipt, :address
	
	def initialize(values = {})
		values = values.with_indifferent_access
		@full_name = values[:full_name]
		@email = values[:email]
		@amount = values[:amount]
		@vendor_amount = values[:vendor_amount]
		@currency = values[:currency]
		@time_stamp = values[:time_stamp]
		@transaction_type = values[:transaction_type].to_sym #TODO: possible memory leak - consider refactoring
		@receipt = values[:receipt]
		
		values[:product] = Product.new(values[:product]) unless values[:product].kind_of? Product
		@product = values[:product]
		values[:address] = Address.new(values[:address]) unless values[:address].kind_of? Address
		@address = values[:address]
	end
	
	def valid?
		case @transaction_type
		when :cancel
			self.receipt.present?
		when :bill
			self.receipt.present? && self.amount.present? && self.currency.present? && self.product.valid?
		when :test
			self.email.present? && self.receipt.present? && self.amount.present? && self.currency.present? && self.product.valid?
		when :refund
			self.receipt.present? && self.amount.present? && self.currency.present?
		end
	end
	
	def self.transaction_types
		@@transaction_types ||= [:test, :bill, :cancel, :refund, :no_funds].freeze
	end
end