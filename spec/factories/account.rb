# Read about factories at https://github.com/thoughtbot/factory_girl

FactoryGirl.define do
  factory :account do
    name								"Test Account"
		sequence :secret_key do |n|
		  "secret_key_#{n}"
		end
		km_api_key					"test kissmetrics api key"
  end
end


