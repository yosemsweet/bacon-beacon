require 'spec_helper'

describe Account do
	it { should respond_to :name }
	it { should respond_to :name= }
	it { should respond_to :secret_key }
	it { should respond_to :secret_key= }
end
