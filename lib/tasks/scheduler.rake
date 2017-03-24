task :run_schedule => :environment do

	p = PardotWrapper.new

	QueuedItem.all.each do |item|

		ps = p.find_prospect_by_email(item.email)
		if ps.present?
			p.assign_visitor_to_prospect_by_id( item.visitor_id, ps["id"] )	
		end

		item.delete
	end

end
