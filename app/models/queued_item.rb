class QueuedItem < ApplicationRecord
	scope :remaining, -> {where(finished: false)}

	def check_complete
		return self.assignment_complete && self.form_handler_complete && self.contact_update_complete			
	end

end
