task :run_schedule => :environment do

	p = PardotWrapper.new

	QueuedItem.all.each do |item|

		ps = p.find_prospect_by_email(item.email)
		if ps.present?
			#assign visitor to prospect
				p.assign_visitor_to_prospect_by_id( item.visitor_id, ps["id"] )	

			#do form handler
				p.form_handler( "http://pi.oshiro1.com/l/337841/2017-03-23/k4q1z", item.email )

			#delete
				item.delete

		end

		
	end

end
