class PayloadWorker
  include Sidekiq::Worker
	sidekiq_options :retry => 3, :backtrace => true

  def perform(payload)
		Rails.logger.error "Perform PayloadWorker with #{payload.class} - #{payload}"
		unless payload.kind_of? Payload
			payload = Payload.new(payload)
			unless payload.kind_of? Payload
				Rails.logger.error "Payload Worker - Invalid Arguments: Payload expected, received #{payload.class}"
				return false
			end
		end
		unless payload.valid?
			Rails.logger.error "Process Worker - Invalid Arguments: invalid payload #{payload.to_yaml}"
			Rails.logger.error "Product Valid? - #{payload.product.valid?}"
			return false
		end
		
		begin
			Notifier.new(payload).notify
			Rails.logger.info "Processed Payload! #{payload}"
		rescue Exception => e
			
		end			
  end
end