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
		
		if params["email"]
			list_cookie = []		
			cookies.each do |cookie|
				list_cookie.push(cookie)
			end

			new_item = QueuedItem.new
			new_item.email = params["email"]
			new_item.cookie = list_cookie.to_json
			new_item.save


			flash[:submitted] = true
		end
		
		redirect_to show_form_path
	end

end
