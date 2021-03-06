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
	order = [:updated_at.desc, :created_at.desc] # results order
	per_page = 5
	
	##
	# Creates a new post. Returns 'status' => Status::OK | Status::ERROR | Status::DENIED.
	# POST => /api/<i>format</i>/post/<i>username</i>/new { <i>text</i> }
	##
  post '/api/:format/post/:username/new' do |format, username|
    return Status::DENIED.format(format, :status) unless logged_in?
    
    inputs = { :text => params[:text] }
    by = current_user
    to = User.first(:username => username)
    
    if inputs[:text].empty? || username.empty?
      return Status::ERROR.format(format, :status)
    elsif to.nil? || by.permission_level == 0
      return Status::DENIED.format(format, :status)
    end
    
    by.posts << Post.new(
    	:to => to.username,
    	:text => inputs[:text]
    )
    return by.save ? Status::OK.format(format, :status) : { :status => Status::DENIED, :error => by.errors.first.first }.to_json
  end
  
	##
	# Edits a post. Returns 'status' => Status::OK | Status::ERROR | Status::NOT_FOUND | Status::DENIED.
	# POST => /api/<i>format</i>/post/<i>username</i>/<i>id</i>/edit { <i>text</i> }
	##
  post '/api/:format/post/:username/:id/edit' do |format, username, id|
    return Status::DENIED.format(format, :status) unless logged_in?
    
    inputs = { :id => id, :text => params[:text], :author => username }
    user = current_user
    author = User.first(:username => inputs[:author])
    post = Post.first(:id => inputs[:id])
    
    if inputs[:id].empty? || !inputs[:id].numeric? || inputs[:text].empty? || inputs[:author].empty?
      return Status::ERROR.format(format, :status)
    elsif author.nil? || (author.permission_level != -1 && author.username != user.username)
      return Status::DENIED.format(format, :status)
    elsif post.nil?
      return Status::NOT_FOUND.format(format, :status)
    end    
    
    update = post.update(
    	:text => inputs[:text]
    )
    return update ? Status::OK.format(format, :status) : Status::ERROR.format(format, :status)
  end
  
	##
	# Deletes a post. Returns 'status' => Status::OK | Status::ERROR | Status::NOT_FOUND | Status::DENIED.
	# POST => /api/<i>format</i>/post/<i>username</i>/<i>id</i>/delete
	##
  post '/api/:format/post/:username/:id/delete' do |format, username, id|
    return Status::DENIED.format(format, :status) unless logged_in?
    
    inputs = { :id => id, :author => username }
    user = current_user
    author = User.first(:username => inputs[:author])
    post = Post.first(:id => inputs[:id])
    
    if inputs[:id].empty? || !inputs[:id].numeric? || inputs[:author].empty?
      return Status::ERROR.format(format, :status)
    elsif author.nil? || (author.permission_level != -1 && author.username != user.username)
      return Status::DENIED.format(format, :status)
    elsif post.nil?
      return Status::NOT_FOUND.format(format, :status)
    end    
    
    return post.destroy ? Status::OK.format(format, :status) : Status::ERROR.format(format, :status)
  end

	##
	# Counts all the posts of <i>username</i>. Returns the integer 'count' or 'status' => Status::ERROR.
	# GET => /api/<i>format</i>/posts/<i>username</i>/count
	##
  get '/api/:format/posts/:username/count' do |format, username|
    return Status::ERROR.format(format, :status) unless user_exists?(:username => username)
    
    Post.count(:user => { :username => username }).format(format, :count)
  end

	##
	# Search all <i>username</i>'s posts for <i>key</i>. Returns the collection or 'status' => Status::ERROR | Status::NOT_FOUND.
	# GET => /api/<i>format</i>/posts/<i>username</i>/search/<i>key</i> ( /<i>page</i> )
	##
  get '/api/:format/posts/:username/search/:key/?:page?' do |format, username, key, page|
    return Status::ERROR.format(format, :status) unless user_exists?(:username => username)
    
    page = 1 if page.nil? || !page.numeric?
    
		Post.all(:user => { :username => username }, :text.like => "%#{key}%").page(page.to_i, :per_page => per_page, :order => order).format(format, exclude)
  end

	##
	# Shows all the posts of <i>username</i>. Returns the collection or 'status' => Status::ERROR | Status::NOT_FOUND.
	# GET => /api/<i>format</i>/posts/<i>username</i>/ ( /<i>page</i> )
	##
  get '/api/:format/posts/:username/?:page?' do |format, username, page|
    return Status::ERROR.format(format, :status) unless user_exists?(:username => username)
    
    page = 1 if page.nil? || !page.numeric?
    
		Post.all(:user => { :username => username }).page(page.to_i, :per_page => per_page, :order => order).format(format, exclude)
  end

	##
	# Shows a post. Returns the object or 'status' => Status::ERROR | Status::NOT_FOUND.
	# GET => /api/<i>format</i>/posts/<i>username</i>/get/<i>id</i>
	##
  get '/api/:format/posts/:username/get/:id' do |format, username, id|
    return Status::ERROR.format(format, :status) unless id.numeric? || user_exists?(:username => username)
    
    Post.first(:id => id, :user => { :username => username }).format(format, exclude)
  end
  
end
