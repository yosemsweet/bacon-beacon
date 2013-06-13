require 'spec_helper'

describe Notifier do
	subject { Notifier.new(nil) }
	
	it { should respond_to :payload }
	
	describe "#initialize" do
		context "with a payload" do
		  let(:payload) { Payload.new }
		
			it "should return a Notifier" do
				Notifier.new(payload).should be_kind_of Notifier
			end

			it "should set payload to be the passed in payload" do
				Notifier.new(payload).payload.should == payload
			end
		end
	end
	
	describe "#notify" do
		let(:payload_attributes) { {transaction_type: :test, receipt: 'test receipt'} }
		
		context "with a valid email in payload" do
			let(:payload_attributes) { {email: 'test@example.com', receipt: 'test receipt'} }
			let(:payload) { Payload.new(payload_attributes) }
		  it "should call KM.identify with the email" do
				KM.should_receive(:identify).with(payload.email).and_call_original
				Notifier.new(payload).notify
			end
			
			it "should alias the email and the receipt" do
				KM.should_receive(:alias) do |email, receipt|
					email.should == payload.email
					receipt.should == payload.receipt.to_s
					true
				end
				Notifier.new(payload).notify
			end
		end
		
		context "without an email" do
			let(:payload_attributes) { { receipt: 'test receipt-sub part', transaction_type: :test } }
			let(:payload) { Payload.new(payload_attributes) }
			
		  it "should call KM.identify with the receipt parent" do
				KM.should_receive(:identify) do |receipt|
					receipt.should == payload.receipt.parent.to_s
					true
				end
				
				Notifier.new(payload).notify
			end
			
			it "should alias the receipt.parent and the receipt" do
				KM.should_receive(:alias) do |parent, receipt|
					parent.should == payload.receipt.parent.to_s
					receipt.should == payload.receipt.to_s
					true
				end
				
				Notifier.new(payload).notify
			end
		end
		
		context "recording events" do
			context "with a :bill transaction_type" do
				let(:payload_attributes) do
					{ receipt: 'test receipt', transaction_type: :bill, amount: 100, currency: 'USD', product: Product.new }
				end
				let(:payload) { Payload.new(payload_attributes) }
			  it "should record a billed event" do
					KM.should_receive(:record).with("Billed", an_instance_of(Hash)).and_call_original

					Notifier.new(payload).notify
				end
			
				context "with USD amounts" do
					it "should pass the amount as a string for the 'billing amount' property" do
						KM.should_receive(:record) do |event_name, properties|
							properties['Billing Amount'].should == payload.amount.to_s
							true
						end
						
						Notifier.new(payload).notify
					end
				end
				
				context "with non-USD amount" do
					let(:payload_attributes) do
						{ receipt: 'test receipt', transaction_type: :bill, amount: 100, currency: 'CAD', product: Product.new }
					end
					let(:payload) { Payload.new(payload_attributes) }
					before(:each) do
					  Money.add_rate("USD", "CAD", 2.0)
						Money.add_rate("CAD", "USD", 0.5)
					end
						
					it "should pass the amount exchanged to USD as a new Money object for the 'billing amount' property" do
						KM.should_receive(:record) do |event_name, properties|
							amount_in_usd = payload.amount.exchange_to("USD")
							properties['Billing Amount'].should == amount_in_usd.to_s
							properties['Currency'].should == "USD"
							true
						end
						
						Notifier.new(payload).notify
					end				  
				end
			end
		end
	end
end