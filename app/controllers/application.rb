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

# Routes and application logic.
class Dafuq

  ##
  # Shows the home.
  # GET /
  ##
  get '/' do
  	@title = 'Dafuq'
    erb :'posts/index'
  end
  
  ##
  # 404 error page
  # GET
  ##
  not_found do
    erb :'404'
  end

  ##
  # Generic error page
  # GET
  ##
  error do
  	@error = env['sinatra.error']
    erb :error
  end

end
