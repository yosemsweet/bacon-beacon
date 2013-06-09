FactoryGirl.define do
	factory :payload do
		email								'test@example.com'
		amount							100
		currency						'USD'
		product							Product.new(id: 1, description: 'Test Product', vendor: 'Test Vendor')
		transaction_type		:test
		receipt							'test receipt'
		initialize_with { new(attributes) }
	end
end