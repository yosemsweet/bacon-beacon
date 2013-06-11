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
		
		@transaction_type = build_transaction_type values[:transaction_type]
		@receipt = values[:receipt]
		
		@product = build_product values[:product] 
		@address = build_address values[:address] 
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
	
	private
	def build_product(args)
		if args.kind_of? Product
			args
		elsif args.present?
			Product.new(args)
		else
			nil
		end
	end
	
	def build_address(args)
		if args.kind_of? Address
			args
		elsif args.present?
			Address.new(args)
		else
			nil
		end
	end
	
	def build_transaction_type(type)
		unless type.kind_of? Symbol
			type = type.to_sym if self.class.transaction_types.map(&:to_s).include?(type)
		end
		if self.class.transaction_types.include?(type)
			return type
		else
			nil
		end
	end
end