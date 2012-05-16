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
	@lang = :en # default client browser language
	order = [:up.desc, :updated_at.desc] # results order
	
	before do
		@lang = (get_cookie('lang') || get_client_language[0, 2]).to_sym
	end
	
	##
	# Creates a new post. Returns Status::OK or the error text.
	# POST => /post/new { <i>username</i>, <i>text</i> }
	##
  post '/api/post/new' do
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
    	:text => params[:text]
    )
    return post.save ? Status::OK : post.errors.first.first.first[lang]
  end
  
	##
	# Edits a post. Returns Status::OK, Status::ERROR or Status::DENIED.
	# POST => /post/edit { <i>id</i>, <i>text</i> }
	##
  post '/api/post/edit' do
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
    	:text => params[:text]
    )
    return update ? Status::OK : Status::ERROR
  end

	##
	# Deletes a post. Returns Status::OK, Status::ERROR or Status::DENIED.
	# POST => /post/destroy { <i>id</i> }
	##
  post '/api/post/destroy' do
  	return Status::DENIED unless cookie_exists?('id') || cookie_exists?('username')
    post = Post.first(
    	:id => params[:id],
    	:user_id => get_cookie('id'),
    	:ip => get_ip,
    	:username => get_cookie('username')
    )
    return Status::DENIED if post == nil
    return post.destroy ? Status::OK : Status::ERROR
  end
  
	##
	# Gives an up to the post. Returns Status::OK, Status::ERROR or Status::DENIED.
	# POST => /post/up { <i>id</i> }
	##
  post '/api/post/up' do
    post = Post.first(
    	:id => params[:id]
    )
    return Status::DENIED if post == nil || post.user_id == get_cookie('id') || get_ip == post.ip
    up = Up.first(
   		:post_id => post.id,
   		:user_id => get_cookie('id'),
   		:ip => get_ip
   	)
    return Status::DENIED unless up == nil
    update = post.update(
    	:up => post.up.to_i + 1
    )
    return Status::ERROR unless update
   	up = Up.new(
   		:post_id => post.id,
   		:user_id => get_cookie('id'),
   		:ip => get_ip
   	)
    return up.save ? Status::OK : Status::ERROR
  end

	##
	# Counts all the posts. Returns Integer.
	# GET => /posts/count
	##
  get '/api/posts/count' do
  	Post.all.count.to_s
  end

	##
	# Shows the posts <i>id</i>. Returns json or <i>.format</i>.
	# GET => /post/id=<i>id</i> ( /<i>format</i> )
	##
  get '/api/post/id=:id/?:format?' do |id, format|
  	post = Post.first(:id => id)
  	format(post, format || default, exclude)
  end

	##
	# Shows all the posts created by <i>username</i>. Returns json array or <i>.format</i>.
	# GET => /posts/username=<i>username</i> ( /<i>page</i>/<i>per_page</i>/<i>format</i> )
	##
  get '/api/posts/username=:username/?:page?/?:per_page?/?:format?' do |username, page, per_page, format|
  	if page == nil
  		post = Post.all(:username => username)
  	else
			per_page = (per_page.is_a?(String) && per_page.numeric?) ? per_page.to_i : 5
			page = (page.is_a?(String) && page.numeric?) ? page.to_i : 1
			post = Post.all(:username => username).page(page, :per_page => per_page, :order => order)
		end
  	format(post, format || default, exclude)
  end

	##
	# Search a post for <i>key</i>. Returns json array or <i>.format</i>.
	# GET => /posts/search/key=<i>key</i> ( /<i>page</i>/<i>per_page</i>/<i>format</i> )
	##
  get '/api/posts/search/key=:key/?:page?/?:per_page?/?:format?' do |key, page, per_page, format|
  	if page == nil
			post = Post.all(:text.like => "%#{key}%")
		else
			per_page = (per_page.is_a?(String) && per_page.numeric?) ? per_page.to_i : 5
			page = (page.is_a?(String) && page.numeric?) ? page.to_i : 1
			post = Post.all(:text.like => "%#{key}%").page(page, :per_page => per_page, :order => order)
		end
  	format(post, format || default, exclude)
  end

	##
	# Shows all the posts created at <i>YYYY/MM/DD</i>. Returns json array or <i>.format</i>.
	# GET => /posts/year=<i>year</i>/month=<i>month</i>/day=<i>day</i> ( /<i>page</i>/<i>per_page</i>/<i>format</i> )
	##
  get '/api/posts/year=:year/month=:month/day=:day/?:page?/?:per_page?/?:format?' do |year, month, day, page, per_page, format|
    # TODO
  end

	##
	# Shows all the posts. Returns json array or <i>.format</i>.
	# GET => /posts ( /page=<i>page</i>/per_page=<i>per_page</i>/<i>format</i> )
	##
  get '/api/posts/?:page?/?:per_page?/?:format?' do |page, per_page, format|
#  	Post.all.each { |p| # Ups cleaning
#  		if p.up.to_i > 0
#  			if (timestamp.to_datetime <=> p.created_at) >= 1
#  				p.update(:up => 0)
#  				Up.all(:post_id => p.id).destroy
#  			end
#  		end
#  	}
		if page == nil
			post = Post.all
		else
			per_page = (per_page.is_a?(String) && per_page.numeric?) ? per_page.to_i : 5
			page = (page.is_a?(String) && page.numeric?) ? page.to_i : 1
			post = Post.page(page, :per_page => per_page, :order => order)
		end
  	format(post, format || default, exclude)
  end
  
end
