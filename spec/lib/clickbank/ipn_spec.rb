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
		
			subject { IpnTester.from_clickbank(valid_payload) }
			
			it { should be_kind_of Payload }
			
			context "with product information" do
			  let(:product_payload) { FactoryGirl.build(:clickbank_payload, cproditem: 42, cprodtitle: 'Test Product', ctranspublisher: 'Test Vendor')}
			
				subject { IpnTester.from_clickbank(product_payload) }
				
				it { subject.product.should be_present }
				it { subject.product.vendor.should == 'Test Vendor' }
				it { subject.product.id.should == 42 }
				it { subject.product.description.should == 'Test Product' }
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