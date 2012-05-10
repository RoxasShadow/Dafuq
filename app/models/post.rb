# Database model. Explains what the posts are.
class Post
  include DataMapper::Resource

  property	:id, Serial
  property	:user_id, String
  property	:ip, String,
	  						:format => /^(\d{1,3}\.\d{1,3}\.\d{1,3}\.\d{1,3})?$/,
								:messages => {
									:format => 'You are strange.'
								}
  property	:username, String,
						:required => true,
						:length => 4..16,
						:format => /\A[a-zA-Z0-9_]*\z/,
						:messages => {
							:presence => 'Username is required',
							:format => 'Username must contains only letters, digits, or underscores.',
							:length => 'Username length must be including betweet 4 and 16 characters.'
						}
  property	:text, Text,
						:required => true,
						:messages => {
							:presence => 'Text is required',
						}
  property	:created_at,	DateTime
  property	:updated_at,	DateTime
  property  :deleted,			ParanoidBoolean
  property  :deleted_at,	ParanoidDateTime
  property  :type,				Discriminator
  
  has n, :comments
  
  before :save, :purge
  def purge
  	self.username = Rack::Utils.escape_html(self.username)
  	self.text = Rack::Utils.escape_html(self.text)
  end  
  
  before :destroy do
    comments.destroy
  end
end
