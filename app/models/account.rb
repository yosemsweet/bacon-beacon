class Account < ActiveRecord::Base
  attr_accessible :name, :secret_key, :km_api_key

	validates :name, presence: true
	validates :secret_key, presence: true
	validates :km_api_key, presence: true
end
