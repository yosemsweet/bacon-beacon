require 'spec_helper'

describe Product do
	it { should respond_to :id }
	it { should respond_to :description }
	it { should respond_to :vendor }
	it { should respond_to :valid? }
	
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
	
	describe "#valid?" do
		context "with id, description, and vendor set" do
			subject { Product.new(id: 1, description: 'Test Product', vendor: 'Test Vendor') }
			it { should be_valid }
		end
		context "with id, and vendor set with description as an empty string" do
			subject { Product.new(id: 1, description: '', vendor: 'Test Vendor') }
			it { should be_valid }
		end
		context "with id, and vendor set with description as nil" do
			subject { Product.new(id: 1, description: nil, vendor: 'Test Vendor') }
			it { should_not be_valid }
		end
		context "with id, and description set with vendor as empty string" do
			subject { Product.new(id: 1, description: 'Test Product', vendor: '') }
			it { should_not be_valid }
		end
		context "with id, and description set with id as empty string" do
			subject { Product.new(id: '', description: 'Test Product', vendor: 'Test Vendor') }
			it { should_not be_valid }
		end
		context "with id, and description set with vendor as nil" do
			subject { Product.new(id: 1, description: 'Test Product', vendor: nil) }
			it { should_not be_valid }
		end
		context "with vendor, and description set with id as nil" do
			subject { Product.new(id: nil, description: 'Test Product', vendor: 'Test Vendor') }
			it { should_not be_valid }
		end
	end
end
