require 'active_support/core_ext/hash/indifferent_access'
require 'clickbank/ipn'

class Payload
	include Clickbank::IPN
	
	class Receipt
		def initialize(receipt_string = '')
			@internal = receipt_string
		end
		
		def to_s
			@internal
		end
		
		def parent
			Receipt.new(@internal.partition('-').first)
		end
		
		def sub_receipt?
			@internal.include? '-'
		end
		
		def sub
			Receipt.new(@internal.partition('-').last)
		end
		
		def == (other)
			@internal == other.to_s
		end
		
		def eql? (other)
			@internal.eql? other.to_s
		end
		
		delegate :present?, to: :@internal
	end
	
	attr_reader :full_name, :email, :amount, :vendor_amount, :currency, :product, :time_stamp, :transaction_type, :receipt, :address
	
	def initialize(values = {})
		Rails.logger.info "Creating payload with #{values}"
		values = values.with_indifferent_access
		@full_name = values[:full_name]
		@email = values[:email]
		@amount = Money.new(values[:amount], values[:currency])
		@vendor_amount = values[:vendor_amount]
		@currency = values[:currency]
		@time_stamp = values[:time_stamp]
		
		@transaction_type = build_transaction_type values[:transaction_type]
		@receipt = Receipt.new(values[:receipt])
		
		@product = build_product values[:product] 
		@address = build_address values[:address] 
		
		Rails.logger.info "Payload.amount == #{self.amount}"
		
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
	
	def to_h
		{
			full_name: self.full_name,
			email: self.email,
			amount: self.amount.cents,
			currency: self.currency,
			product: self.product.to_h,
			time_stamp: self.time_stamp,
			transaction_type: self.transaction_type,
			receipt: self.receipt.to_s,
			address: self.address.to_h
		}
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