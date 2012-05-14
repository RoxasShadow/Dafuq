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

# Routes and application logic relatives to the comments.
class Dafuq
	default = :json # default format
	exclude = [] # fields to exclude by the output
	lang = :en # default client browser language
	
	before do
		lang = get_client_language[0, 2].to_sym # default client browser language
	end
	
	##
	# Creates a new comment. Returns Status::OK, Status::DENIED or the error text.
	# POST => /comment/new { <i>post_id</i>, <i>username</i>, <i>text</i> }
	##
  post '/comment/new' do
  	username = get_cookie('username')
  	id = get_cookie('id')
  	
  	if username == nil || id == nil || username.empty? || username != params[:username]
  		username = params[:username]
  		username = rng(6) if username.empty?
  		id = rng(16)
			set_cookie('id', id)
			set_cookie('username', username)
  	end
  	
  	return Status::DENIED if Post.first(:id => params[:post_id]) == nil
    com = Comment.new(
    				:post_id => params[:post_id],
    				:user_id => id,
    				:ip => get_ip,
    				:username => username,
    				:text => params[:text],
    				:created_at => timestamp
    )
    return com.save ? Status::OK : com.errors.first.first.first[lang]
  end
  
	##
	# Edits a post. Returns Status::OK, Status::ERROR or Status::DENIED.
	# POST => /comment/edit { <i>id</i>, <i>text</i> }
	##
  post '/comment/edit' do
  	return Status::DENIED unless cookie_exists?('id') || cookie_exists?('username')
    com = Comment.first(
    				:id => params[:id],
    				:user_id => get_cookie('id'),
    				:ip => get_ip,
    				:username => get_cookie('username')
    )
    return Status::DENIED if com == nil
    update = com.update(
    	:ip => get_ip,
    	:text => params[:text],
    	:updated_at => timestamp
    )
    return update ? Status::OK : Status::ERROR # .errors works?  				
  end

	##
	# Deletes a post. Returns Status::OK, Status::ERROR or Status::DENIED.
	# POST => /comment/destroy { <i>id</i> }
	##
  post '/comment/destroy' do
  	return Status::DENIED unless cookie_exists?('id') || cookie_exists?('username')
    com = Comment.first(
    				:id => params[:id],
    				:user_id => get_cookie('id'),
    				:ip => get_ip,
    				:username => get_cookie('username')
    )
    return Status::DENIED if com == nil
    return com.destroy ? Status::OK : Status::ERROR # .errors works?  				
  end
  
	##
	# Counts all the comments of a post.
	# GET => /comments/count/<i>id</i>
	##
  get '/comments/count/id=:id' do |post_id|
  	Comment.all(:post_id => post_id).count.to_s
  end

	##
	# Shows all the comments.
	# GET => /comments ( /<i>format</i> )
	##
  get '/comments/?:format?' do |format|
  	com = Comment.all
  	format(com, format || default, exclude)
  end

	##
	# Shows the comment <i>id</i>.
	# GET => /comment/<i>id</i> ( /<i>format</i> )
	##
  get '/comment/id=:id/?:format?' do |id, format|
  	com = Comment.first(:id => id)
  	format(com, format || default, exclude)
  end

	##
	# Shows all the comments of the post <i>id</i>.
	# GET => /comments/post_id=<i>post_id</i> ( /<i>format</i> )
	##
  get '/comments/post_id=:post_id/?:format?' do |post_id, format|
  	com = Comment.all(:post_id => post_id)
  	format(com, format || default, exclude)
  end

	##
	# Shows all the comments created by <i>username</i>.
	# GET => /comments/username=<i>username</i> ( /<i>format</i> )
	##
  get '/comments/username=:username/?:format?' do |username, format|
    com = Comment.first(:username => username)
  	format(com, format || default, exclude)
  end

	##
	# Search a comment for <i>key</i>.
	# GET => /comments/search/key=<i>key</i> ( /<i>format</i> )
	##
  get '/comments/search/key=:key/?:format?' do |key, format|
    com = Comment.find(:text.like => "%#{key}%")
  	format(com, format || default, exclude)
  end

	##
	# Shows all the comments created at <i>YYYY/MM/DD</i>.
	# GET => /comments/year=<i>year</i>/month=<i>month</i>/day=<i>day</i> ( /<i>format</i> )
	##
  get '/comments/year=:year/month=:month/day=:day/?:format?' do |year, month, day, format|
    # TODO
  end
  
end
