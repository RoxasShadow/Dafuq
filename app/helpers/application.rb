class Dafuq
	helpers do	
		def timestamp
			Time.now.getutc
		end			
	
		def rng(len)
			chars = (?a..?z).to_a + (?A..?Z).to_a + (?0..?9).to_a
			charlen = chars.size
			seq = ''
			len.times { seq << chars[rand(charlen-1)] }
			seq
		end
		
		def set_cookie(key, value)
			request.cookie[key] = value
		end
		
		def get_cookie(key)
			request.cookie[key]
		end
		
		def cookie_exists?(key)
			request.cookie[key].empty?
		end
		
		def get_ip
			request.ip
		end
		
		def format(object, format=:json, exclude=[])
			object ||= ''
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
		
		def format_available
			[:json, :xml, :csv, :yaml]
		end
		
		def csrf_token
			Rack::Csrf.csrf_token(env)
		end
		
		def csrf_tag
			Rack::Csrf.csrf_tag(env)
		end
	end
end
