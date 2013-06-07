require 'spec_helper'

describe Product do
	it { should respond_to :id }
	it { should respond_to :description }
	it { should respond_to :vendor }
	
	describe "initialization" do
		context "with a hash of values" do
			let(:values) { Hash.new(id: 'test id', description: 'test description', vendor: 'vendor') }
			it "should be initializable with a hash of values" do
				Product.new(values).should be_kind_of Product
			end
			
			it "should set the attributes according to the hash" do
				product = Product.new(values)
				product.id.should == values[:id]
				product.description.should == values[:description]
				product.vendor.should == values[:vendor]
			end
		end
	end
end
