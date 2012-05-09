# Routes and application logic.
class Dafuq

  ##
  # Shows the home.
  # GET /
  ##
  get '/' do
    erb :index
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
