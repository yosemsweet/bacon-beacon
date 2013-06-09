class Notifier
	attr_reader :payload
	
	def initialize(payload)
		@payload = payload
	end
	
	def notify
		true
	end
end