task :run_schedule => :environment do
	Rails.logger.debug "....starting scheduler.rake"
	p = PardotWrapper.new


	QueuedItem.remaining.each do |item|

			# assign visitor to prespect
			if !item.assignment_complete
				ps = p.find_prospect_by_email(item.email)
				if ps.present?
					if p.assign_visitor_to_prospect_by_id( item.visitor_id, ps["id"] )	
						item.assignment_complete = true
						item.save
						pp item
						p "visitor assignment complete!"
					else
						p "visitor assignment failed..."
					end
				else
					p "skipping #{item.email}. Not found in pardot"
				end
			end

			# simulate form handler
			if !item.form_handler_complete 
				if p.form_handler( "http://pi.oshiro1.com/l/337841/2017-03-23/k4q1z", item.email, item.visitor_id )
					item.form_handler_complete = true
					item.save
					p "form handler simulation complete!"
				else
					p "form handler simulation failed!"
				end
			end

			# update heroku connect table
			if !item.contact_update_complete
				c = Contact.find_by_email( item.email )
				if c.present?						
					c.mypage_last_pardot_visitor_id__c = item.visitor_id
					c.save
					item.contact_update_complete = true
					item.save
					p "visitor_id field updated in connect table!"
				else
					p "skipping #{item.email}. Not found in connect table"
				end

			end

			# check all three and check if its all finished
			if item.check_complete
				item.finished = true
				item.save
			end


		begin

		rescue Exception => e
			p "error occured in run_schedule"
			p e.message
			pp e
		end



		
	end

end


=begin
	

		p "working on #{item.email}"

		ps = p.find_prospect_by_email(item.email)
		p ps
		if ps.present?
			begin
				#assign visitor to prospect
					p.assign_visitor_to_prospect_by_id( item.visitor_id, ps["id"] )	

				#do form handler
					p.form_handler( "http://pi.oshiro1.com/l/337841/2017-03-23/k4q1z", item.email, item.visitor_id )

				#update heroku connect table
					c = Contact.find_by_email( item.email )
					c.mypage_last_pardot_visitor_id__c = item.visitor_id
					c.save
					p "successfully associated #{item.email} to a prospect..."
					
				#delete
					item.delete
				
			rescue Exception => e
				p e.message				
			end
		else
			p "skipping #{item.email}. Not found in pardot"
		end


	
=end