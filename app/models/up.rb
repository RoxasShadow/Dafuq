# encoding: utf-8
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

# Database model. Saves the ups to the posts.
class Up
  include DataMapper::Resource

  property	:id, Serial
  property	:post_id, String
  property	:user_id, String
  property	:ip, String,
	  						:format => /^(\d{1,3}\.\d{1,3}\.\d{1,3}\.\d{1,3})?$/,
								:messages => {
									:format => [ :en => 'You are strange.', :it => 'Sei strano.' ]
								}
end
