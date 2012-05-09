# Routes and application logic relatives to the comments.
class Dafuq
	default = :json # default format
	exclude = [] # fields to exclude by the output
	
	##
	# Creates a new comment. Returns 'ok', 'denied' or the error text.
	# POST => /comment.new { <i>post_id</i>, <i>username</i>, <i>text</i> }
	##
  post '/comment.new' do
  	set_cookie('id', rng(16)) if not cookie_exists? 'id'
  	set_cookie('username', params[:username])
  	'denied' if Post.first(:id => params[:post_id]) == nil
    com = Comment.new(
    				:post_id => params[:post_id],
    				:user_id => get_cookie('id'),
    				:ip => get_ip,
    				:username => params[:username],
    				:text => params[:text],
    				:created_at => timestamp
    )
    return com.save ? 'ok' : com.errors[0]    				
  end
  
	##
	# Edits a post. Returns 'ok', 'error' or 'denied'.
	# POST => /comment.edit { <i>id</i>, <i>text</i> }
	##
  post '/comment.edit' do
  	'denied' if not cookie_exists? 'id'
    'denied' if not cookie_exists? 'username'
    com = Comment.first(
    				:id => params[:id],
    				:user_id => get_cookie('id'),
    				:ip => get_ip,
    				:username => get_cookie('username')
    )
    'denied' if com == nil
    update = com.update(
    	:ip => get_ip,
    	:text => params[:text],
    	:updated_at => timestamp
    )
    return update ? 'ok' : 'error' # .errors works?  				
  end

	##
	# Deletes a post. Returns 'ok', 'error' or 'denied'.
	# POST => /comment.destroy { <i>id</i>, <i>text</i> }
	##
  post '/comment.destroy' do
  	'denied' if not cookie_exists? 'id'
    'denied' if not cookie_exists? 'username'
    com = Comment.first(
    				:id => params[:id],
    				:user_id => get_cookie('id'),
    				:ip => get_ip,
    				:username => get_cookie('username')
    )
    'denied' if com == nil
    return com.destroy ? 'ok' : 'error' # .errors works?  				
  end

	##
	# Shows all the comments.
	# GET => /comments
	##
  get '/comments.?:format?' do
  	com = Comment.all
  	format(com, params[:format] || default, exclude)
  end

	##
	# Shows the comment <i>id</i>.
	# GET => /comment/<i>id</i>
	##
  get '/comment/:id' do |id|
  	com = Comment.first(:id => id)
  	format(com, default, exclude)
  end

	##
	# Shows all the comments of the post <i>id</i>.
	# GET => /comments/post_id=<i>post_id</i>
	##
  get '/comments/post_id=:id' do |post_id|
  	com = Comment.all(:post_id => post_id)
  	format(com, default, exclude)
  end

	##
	# Shows all the comments created by <i>username</i>.
	# GET => /comments/username=<i>username</i>
	##
  get '/comments/username=:username' do |username|
    com = Comment.first(:username => username)
  	format(com, default, exclude)
  end

	##
	# Search a comment for <i>key</i>.
	# GET => /comments.search/<i>key</i>
	##
  get '/comments.search/:key' do |key|
    com = Comment.find(:text.like => "%#{key}%")
  	format(com, default, exclude)
  end

	##
	# Shows all the comments created at <i>YYYY/MM/DD</i>.
	# GET => /comments/<i>year</i>/<i>month</i>/<i>day</i>
	##
  get '/comments/:year/:month/:day' do |year, month, day|
    # TODO
  end
  
end
