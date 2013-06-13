require 'exchanger'

Exchanger.configure! do |config|
	config.cache = :redis
end