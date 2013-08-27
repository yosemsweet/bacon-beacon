# Read about factories at https://github.com/thoughtbot/factory_girl

require 'active_support'

unless defined?(ClickbankPayload)
	class ClickbankPayload < Struct.new(:ccustfullname, :ccustfirstname, :ccustlastname, :ccuststate, :ccustzip, :ccustcc, :ccustaddr1, :ccustaddr2, :ccustcity, :ccustcounty, :ccustshippingstate, :ccustshippingzip, :ccustshippingcountry, :ccustemail, :cproditem, :cprodtitle, :cprodtype, :ctransaction, :ctransaffiliate, :caccountamount, :corderamount, :ctranspaymentmethod, :ccurrency, :ctranspublisher, :ctransreceipt, :ctransrole, :cupsellreceipt, :crebillamnt, :cprocessedpayments, :cfuturepayments, :cnextpaymentdate, :crebillstatus, :ctid, :cevendthru, :cverify, :ctranstime)
		
		def raw
			URI.encode_www_form(self.to_h)
		end
	end
end

FactoryGirl.define do
  factory :clickbank_payload do
    ccustfullname								"Test User"
		ccustfirstname							"TEST"
		ccustlastname								"USER"
		ccustemail									"testuser@somesite.com"
		cproditem										1
		cprodtitle									"A passed in title"
		cprodtype										"STANDARD"
		ctransaction								"TEST"
		caccountamount							100
		corderamount								100
		ctranspaymentmethod					"VISA"
		ccurrency										"USD"
		ctranspublisher							"michaelzen"
		ctransreceipt								"********"
		ctransrole									"VENDOR"
		cverify											"F76AD7A4"
		ctranstime									1370492334
		
		trait :usd do
			ccurrency			"USD"
		end
		
		trait :jpy do
			ccurrency			"JPY"
			corderamount	10000
		end
  end
end

