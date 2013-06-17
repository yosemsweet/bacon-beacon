class PayloadWorker
  include Sidekiq::Worker
	sidekiq_options :retry => 3, :backtrace => true, failures: :exhausted

  def perform(payload)
		raise "Illegal payload #{payload}"  unless payload.kind_of? Hash
		account = Account.where(id: payload["account_id"] || - 1)
		raise "Invalid account_id #{payload['account_id']}"  unless account.size == 1
		account = account.first

		begin
			p = Payload.new(payload)				
		rescue Exception
			raise "Payload Worker - Invalid Arguments: Payload expected, received #{payload.class}"
		end
		payload = p

		unless payload.valid?
			raise "Process Worker - Invalid Arguments: invalid payload #{payload.to_yaml}"
		end
		
		Notifier.new(account, payload).notify
		Rails.logger.info "Processed Payload! #{payload}"
  end
end