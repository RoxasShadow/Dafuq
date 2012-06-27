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

module DataMapper

  class Collection
  
		def format(format=:json, exclude=[])
		  Status::NOT_FOUND.format(format, :status) if self.empty?
		  
			format = format.to_sym if format.is_a? String
			case format
				when :json
					self.to_json(:exclude => exclude)
				when :xml
					self.to_xml(:exclude => exclude)
				when :yaml
					self.to_yaml(:exclude => exclude)
				else
					format(self, :json, exclude)
			end
		end
		
  end

  module Resource
  
		def format(format=:json, exclude=[])
		  Status::NOT_FOUND.format(format, :status) if self.nil?
		  
			format = format.to_sym if format.is_a? String
			case format
				when :json
					self.to_json(:exclude => exclude)
				when :xml
					self.to_xml(:exclude => exclude)
				when :yaml
					self.to_yaml(:exclude => exclude)
				else
					format(self, :json, exclude)
			end
		end
		
  end
  
end
