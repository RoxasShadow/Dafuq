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

class String

	def cut(limit)
		self.match(%r{^(.{0,#{limit}})})[1]
	end
	
	def md5
		Digest::MD5.hexdigest(self)
	end
	
	def numeric?
		self.to_i.to_s == self || self.to_f.to_s == self
	end

	def format(format=:json, type)
    { type => self }.format(format)
  end

end
