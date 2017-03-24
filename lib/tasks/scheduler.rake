task :run_schedule => :environment do



	QueuedItem.all.each do |item|


		cookie_val = ""


		cookies = JSON.parse(item.cookie)
		cookies.each do |cookie|			
			cookie_val  =  cookie_val + "#{cookie[0]}=#{cookie[1]}; "
		end

		p cookie_val

		url = URI.parse("http://localhost:3000/dummy")		
		url = URI.parse("http://pi.oshiro1.com/l/337841/2017-03-23/k4q1z")
		req = Net::HTTP::Post.new(url.path)
		#req["Content-Type"] = "application/x-www-form-urlencoded" 
		req["cookie"] = cookie_val
		req["Content-Type"] = "application/x-www-form-urlencoded"
		#req.basic_auth 'jack', 'pass'
		req.set_form_data({'email'=> item.email}, ';')
		res = Net::HTTP.new(url.host, url.port).start {|http| http.request(req) }


		code = res.code
		p "**code: #{code}/ #{item.email} / #{cookie_val}" 


=begin
	
	
	
http://pi.oshiro1.com/l/337841/2017-03-23/k4q1z	

http = Net::HTTP.new('profil.wp.pl', 443)
http.use_ssl = true
path = '/login.html'


# POST request -> logging in
data = 'serwis=wp.pl&url=profil.html&tryLogin=1&countTest=1&logowaniessl=1&login_username=blah&login_password=blah'
headers = {
  'Cookie' => cookie,
  'Referer' => 'http://profil.wp.pl/login.html',
  'Content-Type' => 'application/x-www-form-urlencoded'
}

resp, data = http.post(path, data, headers)


=end


=begin 


=end

=begin
	
		http = Net::HTTP.new('pi.oshiro1.com', 80)
		#http.use_ssl = true
		path = "/l/337841/2017-03-23/k4q1z"


		# POST request -> logging in
		data = "email=#{item.email}"
		headers = {
		  'cookie' => "visitor_id337841=23277359",
		  'Content-Type' => 'application/x-www-form-urlencoded'
		}

		res = http.post(path, data, headers)
	
=end
		item.delete
	end

end



