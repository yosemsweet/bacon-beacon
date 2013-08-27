require 'spec_helper'
require 'clickbank/ipn'

describe Clickbank::IPN do
	class IpnTester
		include Clickbank::IPN
	end
	
	describe "::from_clickbank" do
		subject { IpnTester }
		it { should respond_to(:from_clickbank).with(1).argument }
		
		context "with valid payload arguments" do
		  let(:valid_payload) { FactoryGirl.build(:clickbank_payload) }
			let(:ipn_payload) { IpnTester.from_clickbank(valid_payload) }
		
			subject { ipn_payload }
			
			it { should be_kind_of Payload }
			context "#raw" do
			  subject { ipn_payload.raw }
				it { should == valid_payload }
			end
			
			context "with product information" do
			  let(:product_payload) { FactoryGirl.build(:clickbank_payload, cproditem: 42, cprodtitle: 'Test Product', ctranspublisher: 'Test Vendor')}
			
				subject { IpnTester.from_clickbank(product_payload) }
				
				it { subject.product.should be_present }
				it { subject.product.vendor.should == 'Test Vendor' }
				it { subject.product.id.should == 42 }
				it { subject.product.description.should == 'Test Product' }
			end
			
			describe "different currencies" do
			  context "with USD amounts" do
			    let(:product_payload) { FactoryGirl.build(:clickbank_payload, :usd, corderamount: 100)}
					
					context "currency code" do
						subject { IpnTester.from_clickbank(product_payload).currency }
						it { should == 'USD' }
					end
					
					context "amount" do
						subject { IpnTester.from_clickbank(product_payload).amount }
					  it { should == Money.new(100, 'USD') }
					end
			  end
			  context "with JPY amounts" do
			    let(:product_payload) { FactoryGirl.build(:clickbank_payload, :jpy, corderamount: 10000)}
					
					context "currency code" do
						subject { IpnTester.from_clickbank(product_payload).currency }
						it { should == 'JPY' }
					end
					
					context "amount" do
						subject { IpnTester.from_clickbank(product_payload).amount }
					  it { should == Money.new(100, 'JPY') }
					end
			  end

			end
		end
	end
	
	describe "::transaction_type" do
		subject { IpnTester }
		it { should respond_to(:transaction_type).with(1).argument }
		
		context "with transaction type TEST" do
			subject { IpnTester.transaction_type("TEST") }
			it { should == :test }
		end
	end
end