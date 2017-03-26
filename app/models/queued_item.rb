class QueuedItem < ApplicationRecord
	after_initialize :set_default
	scope :remaining, -> {where(finished: false)}

	def set_default
		self.finished = false
		self.assignment_complete = false
		self.form_handler_complete = false
		self.contact_update_complete = false
	end

	def check_complete
		return self.assignment_complete && self.form_handler_complete && self.contact_update_complete			
	end

end
