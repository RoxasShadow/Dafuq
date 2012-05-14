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

# Routes and application logic relatives to the posts.
class Dafuq
	default = :json # default format
	exclude = [] # fields to exclude by the output
	lang = :en # default client browser language
	
	before do
		lang = get_client_language[0, 2].to_sym # default client browser language
	end
	
	##
	# Creates a new post. Returns Status::OK or the error text.
	# POST => /post/new { <i>username</i>, <i>text</i> }
	##
  post '/post/new' do
  	username = get_cookie('username')
  	id = get_cookie('id')
  	
  	if username == nil || id == nil || username.empty? || username != params[:username]
  		username = params[:username]
  		username = rng(6) if username.empty?
  		id = rng(16)
			set_cookie('id', id)
			set_cookie('username', username)
  	end
  	
    post = Post.new(
    				:user_id => id,
    				:ip => get_ip,
    				:username => username,
    				:text => params[:text],
    				:created_at => timestamp
    )
    return post.save ? Status::OK : post.errors.first.first.first[lang]
  end
  
	##
	# Edits a post. Returns Status::OK, Status::ERROR or Status::DENIED.
	# POST => /post/edit { <i>id</i>, <i>text</i> }
	##
  post '/post/edit' do
  	return Status::DENIED unless cookie_exists?('id') || cookie_exists?('username')
    post = Post.first(
    				:id => params[:id],
    				:user_id => get_cookie('id'),
    				:ip => get_ip,
    				:username => get_cookie('username')
    )
    return Status::DENIED if post == nil
    update = post.update(
    	:ip => get_ip,
    	:text => params[:text],
    	:updated_at => timestamp
    )
    return update ? Status::OK : Status::ERROR # .errors works?  				
  end

	##
	# Deletes a post. Returns Status::OK, Status::ERROR or Status::DENIED.
	# POST => /post/destroy { <i>id</i> }
	##
  post '/post/destroy' do
  	return Status::DENIED unless cookie_exists?('id') || cookie_exists?('username')
    post = Post.first(
    				:id => params[:id],
    				:user_id => get_cookie('id'),
    				:ip => get_ip,
    				:username => get_cookie('username')
    )
    return Status::DENIED if post == nil
    return post.destroy ? Status::OK : Status::ERROR # .errors works?  				
  end

	##
	# Counts all the posts.
	# GET => /posts/count
	##
  get '/posts/count' do
  	Post.all.count.to_s
  end

	##
	# Shows all the posts.
	# GET => /posts ( /page=<i>page</i>/per_page=<i>per_page</i>/<i>format</i> )
	##
  get '/posts/?page=:page?/?per_page=:per_page?/?:format?' do |page, per_page, format|
  	per_page = (per_page.is_a?(String) && per_page.numeric?) ? per_page.to_i : 5
  	page = (page.is_a?(String) && page.numeric?) ? page.to_i : 1
  	post = Post.page(page, :per_page => per_page)
  	format(post, format || default, exclude)
  end

	##
	# Shows the posts <i>id</i>.
	# GET => /post/id=<i>id</i> ( /<i>format</i> )
	##
  get '/post/id=:id/?:format?' do |id, format|
  	post = Post.first(:id => id)
  	format(post, format || default, exclude)
  end

	##
	# Shows all the posts created by <i>username</i>.
	# GET => /posts/username=<i>username</i> ( /<i>page</i>/<i>per_page</i>/<i>format</i> )
	##
  get '/posts/username=:username/?page=:page?/?per_page=:per_page?/?:format?' do |username, page, per_page, format|
  	post = Post.all(:username => username)
  	format(post, format || default, exclude)
  end

	##
	# Search a post for <i>key</i>.
	# GET => /posts/search/key=<i>key</i> ( /<i>page</i>/<i>per_page</i>/<i>format</i> )
	##
  get '/posts/search/key=:key/?page=:page?/?per_page=:per_page?/?:format?' do |key, page, per_page, format|
  	post = Post.find(:text.like => "%#{key}%")
  	format(post, format || default, exclude)
  end

	##
	# Shows all the posts created at <i>YYYY/MM/DD</i>.
	# GET => /posts/year=<i>year</i>/month=<i>month</i>/day=<i>day</i> ( /<i>page</i>/<i>per_page</i>/<i>format</i> )
	##
  get '/posts/year=:year/month=:month/day=:day/?page=:page?/?per_page=:per_page?/?:format?' do |year, month, day, page, per_page, format|
    # TODO
  end
end
