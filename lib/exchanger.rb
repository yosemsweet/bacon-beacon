require 'money/bank/open_exchange_rates_bank'


class Exchanger
	class << self
		attr_accessor :bank

		def bank
			@bank ||= build_bank
		end

		# Gets called within the initializer
		def configure!
			yield(bank)
			bank.update
		end
	
		private
	
		def build_bank
			Bank.new
		end
	end


	class Bank
		def initialize
			@internal_bank = Money::Bank::OpenExchangeRatesBank.new
			@internal_bank.app_id = '2ebb829edd7541d18529c2779ecb2233'
			Money.default_bank = @internal_bank
		end
	
		def cache=(strategy)
			case strategy
			when :redis
				uri = URI.parse(ENV["REDISTOGO_URL"])
				@redis ||= Redis.new(:host => uri.host, :port => uri.port, :password => uri.password)
				@internal_bank.cache = Proc.new do |rates|
				  key = 'exchange_rates'
				  if rates
				    @redis.set(key, rates)
				  else
				    @redis.get(key)
				  end
				end
			end
			self.update
			self
		end
		
		def cache
			@strategy || :none
		end
		
		def update
			begin
				@internal_bank.save_rates
				@internal_bank.update_rates
			rescue Exception => e
				console.log("Rates not updated #{e.to_s}")
			end
		end
	end
end
