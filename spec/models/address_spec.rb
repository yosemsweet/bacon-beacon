require 'spec_helper'

describe Address do

	it { should respond_to :country_code }
	it { should respond_to :region }
	it { should respond_to :postal_code }
	it { should respond_to :city }
	it { should respond_to :street }

	context "aliases" do
		describe "#state as an alias for region" do
			it { should respond_to :state}
			it "should return the region value" do
				subject.should_receive(:region).and_return("This is a test region")
				subject.state.should == "This is a test region"
			end
		end
		
		context "#state= as an alias for region=" do
			it { should respond_to :state=}
			it "should set the region value" do
				subject.should_receive(:region=).with("test state")
				subject.state = "test state"
			end
		end

	end
	describe "initialization" do
		context "with a hash of values" do
			let(:values) { {country_code: 'US', region: 'WA', city: 'Olympia'} }
			it "should be initializable with a hash of values" do
				Address.new(values).should be_kind_of Address
			end
			
			it "should set the attributes according to the hash" do
				address = Address.new(values)
				address.country_code.should == values[:country_code]
				address.region.should == values[:region]
				address.city.should == values[:city]
			end
		end
	end

end