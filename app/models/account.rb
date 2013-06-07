class Account < ActiveRecord::Base
  attr_accessible :name, :secret_key
end
