require 'spec_helper'
require 'clickbank/ipn'

describe Clickbank::IPN do
	class IpnTester
		extend Clickbank::IPN
	end
	
	describe "::from_clickbank" do
		subject { IpnTester }
		it { should respond_to(:from_clickbank).with(1).argument }
		
		context "with valid payload arguments" do
		  let(:valid_payload) { FactoryGirl.build(:clickbank_payload) }
		
			subject { IpnTester.from_clickbank(valid_payload) }
			
			it { should be_kind_of Payload }
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