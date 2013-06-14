namespace :money do
	desc "Get the latest exchange rates"
	task :update_rates => :environment do
	  puts "Updating rates..."
	  Exchanger.bank.update
	  puts "done."
	end
end