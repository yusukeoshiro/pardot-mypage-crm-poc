class FormController < ApplicationController


	def form
		redirect_to show_form_path

	end


	def top

	end

	def submit
		flash[:submitted] = true
		redirect_to show_form_path
	end

end
