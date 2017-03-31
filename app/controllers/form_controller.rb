class FormController < ApplicationController
	skip_before_action :verify_authenticity_token

	def form
		redirect_to show_form_path

	end


	def verify
		@is_error = false
		@is_success = false

			if params[:verif_code].present?
				# update user
					s = SforceWrapper.new
					r = s.query("SELECT Id FROM Contact WHERE mypage_email_verification_code__c = '#{params[:verif_code]}'")
					pp r
					contact_id = ""
					if r.length > 0
						contact_id = r[0]["Id"]
						payload = {
							"mypage_email_verification_code__c" => nil,
							"mypage_email_verified__c" => true
						}
						s.update_record( "Contact", r[0]["Id"] , payload )
						@is_success = true

					else
						@is_error = true
					end
			else
				@is_error = true
			end

		begin

			
		rescue Exception => e
			@is_error = true			
		end



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
			s = SforceWrapper.new
			#check for same email contact
			email = params["email"]
			q = "SELECT Id FROM Contact where email='#{email}'"
			r = s.query(q)
			contact_id = ""
			pw =  Digest::SHA1.hexdigest params["password"] if params["password"].present?
			verif_code = SecureRandom.hex(32) if params["password"].present?
			payload = {
				"LastName" => params["last_name"],
				"FirstName" => params["first_name"],
				"email" => params["email"],
				"accountid" => "00146000004aS1E",
				"recordtypeid" => "01246000000rEL0",
				"mypage_password__c" => pw,
				"my_page_applied__c" => pw.present?,
				"mypage_email_verification_code__c" => verif_code			

			}

			if r.length > 0 
				# exists				
				s.update_record( "Contact", r[0]["Id"] , payload )
				contact_id = r[0]["Id"]
			else
				# does not exist							
				result = s.insert_record( "Contact", payload )
				contact_id = result[:record_id]
			end

		# insert a case
			payload = {
				"recordtypeid" => "01246000000rELG",
				"Subject" => "予約リクエスト",
				"contactid" => contact_id,
				"description" => params["booking"] 
			}
			result = s.insert_record( "Case", payload )
			flash[:submitted] = true


		# insert to the queue if possible
			if params["email"].present?
				visitor_id = ""
				cookies.each do |cookie|
					visitor_id = cookie[1] if cookie[0] == ENV["PARDOT_VISITOR_ID_KEY"]				
				end

				if visitor_id.present? 
					new_item = QueuedItem.new
					new_item.email = params["email"]
					new_item.visitor_id = visitor_id
					new_item.save					
				end
			end
			
		redirect_to show_form_path
	end



end
