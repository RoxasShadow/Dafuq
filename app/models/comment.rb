# encoding: utf-8
# Database model. Explains what the comments are.
class Comment
  include DataMapper::Resource

  property	:id, Serial
  property  :post_id, Integer
  property	:user_id, String
  property  :ip, String,
	  						:format => /^(\d{1,3}\.\d{1,3}\.\d{1,3}\.\d{1,3})?$/,
								:messages => {
									:format => [ :en => 'You are strange.', :it => 'Sei strano.' ]
								}
  property	:username, String,
						:required => true,
						:length => 4..16,
						:format => /\A[a-zA-Z0-9_]*\z/,
						:messages => {
							:presence => [ :en => 'Username required.', :it => 'L\'username è richiesto.' ],
							:format => [ :en => 'Username must contain only letters, numbers and underscores.', :it => 'L\'username deve contenere solo lettere, numeri e underscore.' ],
							:length => [ :en => 'Username length must be including between 4 and 16 characters.', :it => 'La lunghezza dell\'username deve essere inclusa tra i 4 e i 16 caratteri.' ] 
						}
  property	:text, Text,
						:required => true,
						:messages => {
							:presence => [ :en => 'Text required.', :it => 'Il testo è richiesto.' ]
						}
  property	:created_at,	DateTime
  property	:updated_at,	DateTime
  property  :deleted,			ParanoidBoolean
  property  :deleted_at,	ParanoidDateTime
  property  :type,				Discriminator
  
  belongs_to :post
  
  before :save, :purge
  def purge
  	self.username = Rack::Utils.escape_html(self.username)
  	self.text = Rack::Utils.escape_html(self.text)
  end
end
