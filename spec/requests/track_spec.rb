require 'spec_helper'

describe "Tracking" do
	context "account specific paths" do
		context "with an existing account" do
		  let(:account) { FactoryGirl.create(:account) }
		
			describe "POST /accounts/:id/ipn" do		
				context "with a valid payload" do
					let!(:payload) { FactoryGirl.build(:clickbank_payload) }
			
					it "should return success" do
						post track_account_path(account), params: payload.to_h
						response.should be_success
					end
					
					it "should increase the size of the PayloadWorker queue by 1" do
						expect {
							post track_account_path(account), params: payload.to_h
						}.to change { PayloadWorker.jobs.size }.by(1)
					end
				end
			end
		end
	end
end