require 'spec_helper'

describe PayloadWorker do
	it {should respond_to :perform }

	describe "#perform" do
		let(:KM) do
			double('KM').tap do |km|
				km.stub(:init).and_return(km)
				km.stub(:identify) { |id| id }
				km.stub(:record) { |action, properties| "KM Record called with #{action} - #{properties}" }
				km.stub(:alias) { |name, other_name| "KM Alias called with #{name} - #{other_name}" }
				km.stub(:set) { |data| "KM Set called with #{set}" }
			end
		end
		
	  context "with invalid arguments" do
			it "should raise an exception" do
				expect {
					PayloadWorker.new.perform(:invalid_arguments)
				}.to raise_error
			end
	  end
	
		context "with valid arguments" do
			# Need to use let! because we stub out Payload.new later
			let!(:payload) {FactoryGirl.build(:payload) }
			let(:account) { mock_model(Account) }
		  let!(:valid_arguments) { payload.to_h.merge("account_id" => account.id) }

			before(:each) do
				Account.stub(:where).with(id: account.id).and_return([account])
				Payload.stub(:new).with(valid_arguments).and_return(payload)
			end

			it "should create a new notifier with payload" do
				Notifier.should_receive(:new).with(account, payload).and_call_original
				PayloadWorker.new.perform(valid_arguments)
			end
		end
	end
	
end