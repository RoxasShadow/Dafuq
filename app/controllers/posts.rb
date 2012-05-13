# Routes and application logic relatives to the posts.
class Dafuq
	default = :json # default format
	exclude = [] # fields to exclude by the output
	
	##
	# Creates a new post. Returns 'ok' or the error text.
	# POST => /post.new { <i>username</i>, <i>text</i> }
	##
  post '/post.new' do
  	username = get_cookie('username')
  	id = get_cookie('id')
  	
  	if username.empty? || username != params[:username] || username == nil || id == nil
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
    return post.save ? 'ok' : post.errors.first.first
  end
  
	##
	# Edits a post. Returns 'ok', 'error' or 'denied'.
	# POST => /post.edit { <i>id</i>, <i>text</i> }
	##
  post '/post.edit' do
  	return 'denied' unless cookie_exists?('id') || cookie_exists?('username')
    post = Post.first(
    				:id => params[:id],
    				:user_id => get_cookie('id'),
    				:ip => get_ip,
    				:username => get_cookie('username')
    )
    return 'denied' if post == nil
    update = post.update(
    	:ip => get_ip,
    	:text => params[:text],
    	:updated_at => timestamp
    )
    return update ? 'ok' : 'error' # .errors works?  				
  end

	##
	# Deletes a post. Returns 'ok', 'error' or 'denied'.
	# POST => /post.destroy { <i>id</i> }
	##
  post '/post.destroy' do
  	return 'denied' unless cookie_exists?('id') || cookie_exists?('username')
    post = Post.first(
    				:id => params[:id],
    				:user_id => get_cookie('id'),
    				:ip => get_ip,
    				:username => get_cookie('username')
    )
    return 'denied' if post == nil
    return post.destroy ? 'ok' : 'error' # .errors works?  				
  end

	##
	# Shows all the posts.
	# GET => /posts
	##
  get '/posts/?:format?' do |format|
  	post = Post.all
  	format(post, format || default, exclude)
  end

	##
	# Shows the posts <i>id</i>.
	# GET => /post/<i>id</i>
	##
  get '/post/:id/?:format?' do |id, format|
  	post = Post.first(:id => id)
  	format(post, format || default, exclude)
  end

	##
	# Shows all the posts created by <i>username</i>.
	# GET => /posts/username=<i>username</i>
	##
  get '/posts/username=:username/?:format?' do |username, format|
  	post = Post.all(:username => username)
  	format(post, format || default, exclude)
  end

	##
	# Search a post for <i>key</i>.
	# GET => /posts.search/<i>key</i>
	##
  get '/posts.search/:key/?:format?' do |key, format|
  	post = Post.find(:text.like => "%#{key}%")
  	format(post, format || default, exclude)
  end

	##
	# Shows all the posts created at <i>YYYY/MM/DD</i>.
	# GET => /posts/<i>year</i>/<i>month</i>/<i>day</i>
	##
  get '/posts/:year/:month/:day/?:format?' do |year, month, day, format|
    # TODO
  end
end
