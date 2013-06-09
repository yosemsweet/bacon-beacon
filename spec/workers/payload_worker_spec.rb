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
			it "should log an error" do
				Rails.logger.should_receive(:error)
				PayloadWorker.new.perform(:invalid_arguments)
			end
	  end
	
		context "with valid arguments" do
			let(:payload) {FactoryGirl.build(:payload) }
		  let(:valid_arguments) { payload }

			context "without an existing account" do
				it "should not create a new account" do
					Notifier.should_receive(:new).with(payload)
					PayloadWorker.new.perform(valid_arguments)
				end			  
			end
		end
	end
	
end