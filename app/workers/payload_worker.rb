class PayloadWorker
  include Sidekiq::Worker

  def perform(payload)
		unless payload.kind_of? Payload
			Rails.logger.error "Payload Worker - Invalid Arguments: Payload expected, received #{payload.class}"
			return false
		end
		unless payload.valid?
			Rails.logger.error "Process Worker - Invalid Arguments: invalid payload #{payload.to_yaml}"
			return false
		end
		
		begin
			Notifier.new(payload).notify
		rescue Exception => e
			
		end			
  end
end