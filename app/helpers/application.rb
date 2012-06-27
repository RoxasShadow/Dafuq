#--
# Copyright(C) 2012 Giovanni Capuano <webmaster@giovannicapuano.net>
#
# This file is part of Dafuq.
#
# Dafuq is free software: you can redistribute it and/or modify
# it under the terms of the GNU General Public License as published by
# the Free Software Foundation, either version 3 of the License, or
# (at your option) any later version.
#
# Dafuq is distributed in the hope that it will be useful,
# but WITHOUT ANY WARRANTY; without even the implied warranty of
# MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
# GNU General Public License for more details.
#
# You should have received a copy of the GNU General Public License
# along with Dafuq.  If not, see <http://www.gnu.org/licenses/>.
#++

class Dafuq

	helpers do
	
		# Returns the actual time and date in UTC format.
		def timestamp
			Time.now.getutc
		end
		
		# Formats a date with the given pattern.
		def format_date(date, format="%Y/%m/%d")
			date.strftime(format)
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
		
		# Returns the preferred language of the user.
		def get_client_language
			request.env['HTTP_ACCEPT_LANGUAGE']
		end
  
    # Encrypt with SHA1 one or more concatenated strings.
    def encrypt(*str)
      Digest::SHA1.hexdigest(str.join)
    end
    
    # Returns a pseudo-random string.
    def random_string(len)
      chars = ("a".."z").to_a + ("A".."Z").to_a + ("0".."9").to_a
      newpass = ""
      1.upto(len) { |i| newpass << chars[rand(chars.size-1)] }
      return newpass
    end; alias rng random_string
		
	end
	
end
