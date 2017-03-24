class FormController < ApplicationController
	skip_before_action :verify_authenticity_token

	def form
		redirect_to show_form_path

	end


	def dummy
		p request.headers["Content-Type"]
		p request.headers["cookie"]
		
	end

	def top
		list_cookie = []		
		cookies.each do |cookie|
			list_cookie.push(cookie)
			pp list_cookie
		end

		
	end



	def submit

		# upsert to salesforce
			s = SforceWrapper.new(ENV["SFDC_EMAIL"],ENV["SFDC_PASSWORD"])
			
			payload = {
				"LastName" => params["last_name"],
				"FirstName" => params["first_name"],
				"email" => params["email"],
				"accountid" => "00146000004aS1E",
				"recordtypeid" => "01246000000rEL0"
			}
			s.insert_record( "Contact", payload )


		# insert to the queue
			if params["email"]
				visitor_id = ""
				cookies.each do |cookie|
					visitor_id = cookie[1] if cookie[0] == ENV["PARDOT_VISITOR_ID_KEY"]				
				end

				if visitor_id 
					new_item = QueuedItem.new
					new_item.email = params["email"]
					new_item.visitor_id = visitor_id
					new_item.save
					flash[:submitted] = true
				end
			end
			
		redirect_to show_form_path
	end

end
