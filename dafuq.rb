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
require 'dm-serializer' # to_json, to_csv, to_yaml, to_xml methods
require 'dm-pager' # Post.page
require 'rack/csrf' # csrf protection

class Dafuq < Sinatra::Base
  DataMapper.setup(:default, "sqlite3://#{Dir.pwd}/db/database.db")
	enable :sessions
	
  configure do
    set :method_override, true
    set :views, settings.root + '/app/views'
    set :public_folder, settings.root + '/app/assets'
  	use Rack::Session::Cookie
  	use Rack::Csrf, :raise => true
  end

  # Require Models & Controllers
  Dir.glob("#{Dir.pwd}/app/helpers/*.rb") { |m| require m.chomp }
  Dir.glob("#{Dir.pwd}/app/models/*.rb") { |m| require m.chomp }
  Dir.glob("#{Dir.pwd}/app/controllers/*.rb") { |m| require m.chomp }

  DataMapper.finalize
  DataMapper::auto_upgrade!
end
