# Routes and application logic relatives to the posts.
class Dafuq
	default = :json
	exclude = []
	
	##
	# Creates a new post. Returns 'ok' or the error text.
	# POST => /post.new { <i>username</i>, <i>text</i> }
	##
  post '/post.new' do
  	set_cookie('id', rng(16)) if not cookie_exists? 'id'
  	set_cookie('username', params[:username])
    post = Post.new(
    				:user_id => get_cookie('id'),
    				:ip => get_ip,
    				:username => params[:username],
    				:text => params[:text],
    				:created_at => timestamp
    )
    return post.save ? 'ok' : post.errors[0]    				
  end
  
	##
	# Edits a post. Returns 'ok', 'error' or 'denied'.
	# POST => /post.edit { <i>id</i>, <i>text</i> }
	##
  post '/post.edit' do
  	'denied' if not cookie_exists? 'id'
    'denied' if not cookie_exists? 'username'
    post = Post.first(
    				:id => params[:id],
    				:user_id => get_cookie('id'),
    				:ip => get_ip,
    				:username => get_cookie('username')
    )
    'denied' if post == nil
    update = post.update(
    	:ip => get_ip,
    	:text => params[:text],
    	:updated_at => timestamp
    )
    return update ? 'ok' : 'error' # .errors works?  				
  end

	##
	# Deletes a post. Returns 'ok', 'error' or 'denied'.
	# POST => /post.destroy { <i>id</i>, <i>text</i> }
	##
  post '/post.destroy' do
  	'denied' if not cookie_exists? 'id'
    'denied' if not cookie_exists? 'username'
    post = Post.first(
    				:id => params[:id],
    				:user_id => get_cookie('id'),
    				:ip => get_ip,
    				:username => get_cookie('username')
    )
    'denied' if post == nil
    return post.destroy ? 'ok' : 'error' # .errors works?  				
  end

	##
	# Shows all the posts.
	# GET => /posts
	##
  get '/posts' do
  	post = Post.all
  	format(post, default, exclude)
  end

	##
	# Shows the posts <i>id</i>.
	# GET => /post/<i>id</i>
	##
  get '/post/:id' do |id|
  	post = Post.first(:id => id)
  	format(post, default, exclude)
  end

	##
	# Shows all the posts created by <i>username</i>.
	# GET => /posts/username=<i>username</i>
	##
  get '/posts/username=:username' do |username|
  	post = Post.all(:username => username)
  	format(post, default, exclude)
  end

	##
	# Search a post for <i>key</i>.
	# GET => /posts.search/<i>key</i>
	##
  get '/posts.search/:key' do |key|
  	post = Post.find(:text.like => "%#{key}%")
  	format(post, default, exclude)
  end

	##
	# Shows all the posts created at <i>YYYY/MM/DD</i>.
	# GET => /posts/<i>year</i>/<i>month</i>/<i>day</i>
	##
  get '/posts/:year/:month/:day' do |year, month, day|
    # TODO
  end
end
