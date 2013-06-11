require 'spec_helper'

describe Payload do
	it { should respond_to :full_name }
	it { should respond_to :email }
	it { should respond_to :amount }
	it { should respond_to :vendor_amount }
	it { should respond_to :currency }
	it { should respond_to :product }
	it { should respond_to :time_stamp }
	it { should respond_to :transaction_type }
	it { should respond_to :receipt }
	it { should respond_to :address }
	
	it { should respond_to :valid? }
	
	describe "#initialize" do
		it "should be initializable with a hash of values" do
			Payload.new({full_name: 'test name', email: 'test@email.com' }).should be_kind_of Payload
		end
		
		it "should set the attributes of the created Payload based on the values hash" do
			p = Payload.new({full_name: 'test name', email: 'test@email.com' })
			p.full_name.should == 'test name'
			p.email.should == 'test@email.com'
		end
	end
	
	describe "#valid?" do
		context "with transaction_type == :cancel" do
			let(:transaction_type) { :cancel }
			context "with a receipt" do
			  subject { Payload.new(receipt: 'a valid receipt', transaction_type: transaction_type) }
				it { should be_valid }
			end
		  context "without a valid receipt" do
				context "receipt is nil" do
		    	subject { FactoryGirl.build(:payload, transaction_type: transaction_type, receipt: nil)}
					it { should_not be_valid }
				end
				context "receipt is an empty string" do
		    	subject { FactoryGirl.build(:payload, transaction_type: transaction_type, receipt: '')}
					it { should_not be_valid }
				end
		  end
		end
		context "with transaction_type == :bill" do
			let(:transaction_type) { :bill }
		  let(:valid_params) do
				{ receipt: 'a valid receipt', transaction_type: transaction_type, amount: 100, currency: 'USD', product: Product.new(id: 1, description: 'test product', vendor: 'test vendor') }
			end
			context "with valid params (a receipt, a product, an amount, a currency)" do

				subject { Payload.new(valid_params) }
				it { should be_valid }
			end
			not_nillable_properties = [:receipt, :amount, :currency].each do |property|
				context "with a nil #{property}" do
					let(:invalid_params) do valid_params.merge({property => nil}) end
					
				  subject { Payload.new(invalid_params) }
					it { should_not be_valid }
				end
			end
		end
		context "with transaction_type == :test" do
			let(:transaction_type) { :test }
		  let(:valid_params) do
				{ receipt: 'a valid receipt', transaction_type: transaction_type, email: 'test@example.com', amount: 100, currency: 'USD', product: Product.new(id: 1, description: 'test product', vendor: 'test vendor') }
			end
			context "with valid params (an email, a receipt, a product, an amount, a currency)" do

				subject { Payload.new(valid_params) }
				it { should be_valid }
			end
			not_nillable_properties = [:email, :receipt, :amount, :currency].each do |property|
				context "with a nil #{property}" do
					let(:invalid_params) do valid_params.merge({property => nil}) end
					
				  subject { Payload.new(invalid_params) }
					it { should_not be_valid }
				end
			end
		end
	end
end
