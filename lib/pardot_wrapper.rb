class PardotWrapper
	attr_accessor :api_key

	def initialize( email=ENV["PARDOT_EMAIL"], password=ENV["PARDOT_PASSWORD"], user_key=ENV["PARDOT_KEY"])

		uri = URI.parse('https://pi.pardot.com/api/login/version/3') 
		email    = URI.encode_www_form_component( email )
		password = URI.encode_www_form_component( password )
		key      = URI.encode_www_form_component( user_key )
		param = "email=#{email}&password=#{password}&user_key=#{key}&format=json"		
		https = Net::HTTP.new(uri.host, 443)
		https.use_ssl = true
		https.verify_mode = OpenSSL::SSL::VERIFY_PEER
		res = https.post(
		    uri.request_uri, param
		)
		response = JSON.parse(res.body)
		self.api_key = response["api_key"]
		
	end

	def query_visitor( visitor_id, user_key=ENV["PARDOT_KEY"])
		uri = URI.parse("https://pi.pardot.com/api/visitor/version/4/do/read/id/#{visitor_id}") 
		param = "api_key=#{self.api_key}&user_key=#{user_key}&format=json"		
		https = Net::HTTP.new(uri.host, 443)
		https.use_ssl = true
		https.verify_mode = OpenSSL::SSL::VERIFY_PEER
		res = https.post(
		    uri.request_uri, param
		)
		response = JSON.parse(res.body)
		return response
	end

	def find_prospect_by_email( email, user_key=ENV["PARDOT_KEY"] )

		uri = URI.parse("https://pi.pardot.com/api/prospect/version/4/do/read/email/#{email}") 
		param = "api_key=#{self.api_key}&user_key=#{user_key}&email=#{email}&format=json"		
		https = Net::HTTP.new(uri.host, 443)
		https.use_ssl = true
		https.verify_mode = OpenSSL::SSL::VERIFY_PEER
		res = https.post(
		    uri.request_uri, param
		)
		response = JSON.parse(res.body)
		
		if response["prospect"].instance_of?(Array)
			return response["prospect"][0]
		else
			return response["prospect"]
		end
	end


	def assign_visitor_to_prospect_by_id( visitor_id, prospect_id , user_key=ENV["PARDOT_KEY"] )
		uri = URI.parse("https://pi.pardot.com/api/visitor/version/4/do/assign/id/#{visitor_id}") 
		param = "api_key=#{self.api_key}&user_key=#{user_key}&prospect_id=#{prospect_id}&id=#{visitor_id}&format=json"	
		p param
		https = Net::HTTP.new(uri.host, 443)
		https.use_ssl = true
		https.verify_mode = OpenSSL::SSL::VERIFY_PEER
		res = https.post(
		    uri.request_uri, param
		)
		response = JSON.parse(res.body)
	end



end
