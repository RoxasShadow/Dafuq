# Helpers (various methods to be used in the controllers).
class Dafuq
	helpers do
	
		# Returns the actual time and data in UTC format.
		def timestamp
			Time.now.getutc
		end
		
		# Formats a date with the given pattern.
		def format_date(date, format="%Y/%m/%d")
			date.strftime(format)
		end 
	
		# Random string alphanumeric of length "len".
		def rng(len)
			chars = (?a..?z).to_a + (?A..?Z).to_a + (?0..?9).to_a
			charlen = chars.size
			seq = ''
			len.times { seq << chars[rand(charlen-1)] }
			seq
		end
		
		# Set the cookie with the name "key" and content "value".
		def set_cookie(key, value)
			response.set_cookie(key, value)
		end
		
		# Deletes the cookie with the name "key".
		def delete_cookie(key)
			set_cookie(key, nil)
		end
		
		# Returns the content of the cookie with the name "key".
		def get_cookie(key)
			request.cookies[key]
		end
		
		# Returns true if exists a cookie with the name "key".
		# false otherwise.
		def cookie_exists?(key)
			request.cookies[key].is_a? String
		end
		
		# Returns the user IP.
		def get_ip
			request.ip
		end
		
		# Returns the CSRF token inner a HTML tag.
		def csrf_token
			Rack::Csrf.csrf_token(env)
		end
		
		# Returns the CSRF token.
		def csrf_tag
			Rack::Csrf.csrf_tag(env)
		end
		
		# Returns the client browser language
		def get_client_language
			request.env['HTTP_ACCEPT_LANGUAGE']
		end
		
		# Formats a DataMapper object.
		def format(object, format=:json, exclude=[])
			return Status::NOT_FOUND unless object.is_a?(Post) or object.is_a?(Comment) or object.is_a?(Array)
			return Status::NOT_FOUND if object.is_a?(Array) and object.length == 0 
			format = format.to_sym if format.is_a? String
			case format
				when :json
					object.to_json(:exclude => exclude)
				when :xml
					object.to_xml(:exclude => exclude)
				when :csv
					object.to_csv(:exclude => exclude)
				when :yaml
					object.to_yaml(:exclude => exclude)
				else
					format(object, :json, exclude)
			end
		end
		
	end
end
