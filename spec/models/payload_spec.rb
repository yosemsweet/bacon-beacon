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
end
