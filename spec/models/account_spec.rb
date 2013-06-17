require 'spec_helper'

describe Account do
	it { should respond_to :name }
	it { should respond_to :name= }
	it { should respond_to :secret_key }
	it { should respond_to :secret_key= }
	it { should respond_to :km_api_key }
	it { should respond_to :km_api_key= }
	
	it { should validate_presence_of :name }
	it { should validate_presence_of :secret_key }
	it { should validate_presence_of :km_api_key }
end
