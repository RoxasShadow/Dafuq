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

require 'sinatra/base' # framework
require 'data_mapper' # database
require 'dm-sqlite-adapter' # sqlite database
require 'dm-constraints' # :constraint => :destroy
require 'dm-serializer' # to_json, to_csv, to_yaml, to_xml methods for DataMapper
require 'dm-pager' # Post.page
require 'active_record' # to_json, to_csv, to_yaml, to_xml methods for Object
require 'rack/csrf' # csrf protection

class Dafuq < Sinatra::Base
  include ActiveRecord::Serialization
  
  DataMapper.setup(:default, "sqlite3://#{Dir.pwd}/db/database.db")
	
  configure do
    set :method_override, true
  	use Rack::Session::Cookie, :path => '/', :secret => 'A1 sauce 1s so good you should use 1t on a11 yr st34ksssss'
  	#use Rack::Csrf, :raise => true
  end
  
  Dir.glob("#{Dir.pwd}/app/helpers/*.rb") { |m| require m.chomp }
  Dir.glob("#{Dir.pwd}/app/models/*.rb") { |m| require m.chomp }; DataMapper.finalize
  Dir.glob("#{Dir.pwd}/app/controllers/*.rb") { |m| require m.chomp }

  DataMapper::auto_upgrade!
end
