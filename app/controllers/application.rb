class Dafuq

  get '/' do
    'Hello, world!'
  end
  
	set(:probability) { |value| condition { rand <= value } }
	get '/win', :probability => 0.1 do
		'yes'
	end
	get '/win' do
		'nope'
	end

end
