class QueuedItem < ApplicationRecord
	scope :remaining, -> {where(finished: false)}
	after_initialize :set_default
	validates :visitor_id, presence: true
	validates :email, presence: true

	def set_default
		self.finished                = false if self.finished.nil?
		self.assignment_complete     = false if self.assignment_complete.nil?
		self.form_handler_complete   = false if self.form_handler_complete.nil?
		self.contact_update_complete = false if self.contact_update_complete.nil?
		self.retry_count             = 0     if self.retry_count.nil? 		
	end


	def check_complete
		return self.assignment_complete && self.form_handler_complete && self.contact_update_complete			
	end

end
