if Rails.env.production?
	HireFire::Resource.configure do |config|
	  config.dyno(:worker) do
	    HireFire::Macro::Sidekiq.queue
	  end
	end
end