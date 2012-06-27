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

	exclude = [] # fields to exclude by the output
	order = [:username.asc] # results order

	##
	# Checks if you are logged. Returns 'status' => Status::OK | Status::NOT.
	# GET => /api/<i>format</i>/user/logged
	##
  get '/api/:format/user/logged' do |format|
    return logged_in? ? Status::OK.format(format, :status) : Status::NOT.format(format, :status)
  end

	##
	# Performs the user login. Returns 'status' => Status::OK | Status::ERROR | Status::DENIED.
	# POST => /api/<i>format</i>/user/login { <i>username</i>, <i>password</i> }
	##
  post '/api/:format/user/login' do |format|
    return Status::DENIED.format(format, :status) if logged_in?
    
    if user = User.authenticate(params[:username], params[:password])
      update = user.update(:secret => User.random_string(10), :last_ip => get_ip)
      set_cookie 'user', user.secret
      return update ? Status::OK.format(format, :status) : Status::ERROR.format(format, :status)
    end
    
    return Status::DENIED.format(format, :status)
  end
	
	##
	# Performs the user logout. Returns nothing.
	# POST => /api/<i>format</i>/user/logout
	##
  post '/api/:format/user/logout' do |format|
    delete_cookie('user')
    return Status::OK.format(format, :status)
  end
	
	##
	# Creates a new user. Returns 'status' => Status::OK | Status::DENIED.
	# POST => /api/<i>format</i>/user/signup { <i>username</i>, <i>email</i>, <i>password</i>, <i>password_confirmation</i> }
	##
  post '/api/:format/user/signup' do |format|
    return Status::DENIED.format(format, :status) if logged_in?
    
    inputs = { :first_ip => get_ip, :username => params[:username], :email => params[:email], :password => params[:password], :password_confirmation => params[:password_confirmation] }
    
    user = User.new(inputs)
    
    if user.save
      set_cookie 'user', user.id
      return Status::OK.format(format, :status)
    end
    
    return { :status => Status::DENIED, :error => user.errors.first.first }.to_json
  end
  
	##
	# Edits an user. Returns 'status' => Status::OK | Status::DENIED.
	# POST => /api/<i>format</i>/user/<i>username</i>/edit ( <i>email</i>, <i>password</i>, <i>password_confirmation</i> )
	##
  post '/api/:format/user/:username/edit' do |format|
    return Status::DENIED.format(format, :status) unless logged_in? || current_user.admin? || current_user.username == params[:username]
    
    inputs = { :username => params[:username], :email => params[:email], :password => params[:password], :password_confirmation => params[:password_confirmation] }
    
    if inputs[:password].empty? || inputs[:password] != inputs[:password_confirmation]
      inputs.delete(:password)
      inputs.delete(:password_confirmation)
    end
    
    inputs.delete(:email) if inputs[:email].empty?
    
    return User.first(:username => params[:username]).update(inputs) ? Status::OK.format(format, :status) : Status::DENIED.format(format, :status)
  end

	##
	# Deletes an user. Returns 'status' => Status::OK | Status::DENIED.
	# POST => /api/<i>format</i>/user/<i>username</i>/delete
	##
  post '/api/:format/user/:username/delete' do |format, username|
    return Status::DENIED.format(format, :status) unless logged_in? || current_user.admin? || current_user.username == username
    
    return User.destroy(:username => username) ? Status::OK.format(format, :status) : Status::DENIED.format(format, :status)
  end

	##
	# Counts all the users. Returns the integer 'count'.
	# GET => /api/<i>format</i>/users/count
	##
  get '/api/:format/users/count' do |format|
  	User.count.format(format, :count)
  end

	##
	# Search users for <i>key</i>. Returns the collection or 'status' => Status::NOT_FOUND.
	# GET => /api/<i>format</i>/users/search/<i>key</i>
	##
  get '/api/:format/users/search/:key' do |format, key|
    results = (
      User.all(:username.like => "%#{key}%") | User.all(:email.like => "%#{key}%")
    )
    return Status::NOT_FOUND.format(format, :status) if results.empty?
    
    results.format(format, exclude)
  end

	##
	# Shows an user. Returns the object or 'status' => Status::OK | Status::NOT_FOUND.
	# GET => /api/<i>format</i>/users/get/<i>username</i>
	##
  get '/api/:format/users/get/:username' do |format, username|
    User.first(:username => username).format(format, exclude)
  end

	##
	# Shows all the users. Returns the collection or 'status' => Status::NOT_FOUND.
	# GET => /api/<i>format</i>/users/
	##
  get '/api/:format/users' do |format|
    User.all.format(format, exclude)
  end
  
end
