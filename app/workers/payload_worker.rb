class PayloadWorker
  include Sidekiq::Worker
	sidekiq_options :retry => 3, :backtrace => true, failures: :exhausted

  def perform(payload)
		unless payload.kind_of? Payload
			begin
				p = Payload.new(payload)				
			rescue Exception
				Rails.logger.error "Payload Worker - Invalid Arguments: Payload expected, received #{payload.class}"
				return false
			end
			payload = p
		end
		unless payload.valid?
			Rails.logger.error "Process Worker - Invalid Arguments: invalid payload #{payload.to_yaml}"
			Rails.logger.error "Product Valid? - #{payload.product.valid?}"
			return false
		end
		
		Notifier.new(payload).notify
		Rails.logger.info "Processed Payload! #{payload}"
  end
end