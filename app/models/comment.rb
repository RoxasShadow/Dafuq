class Comment
  include DataMapper::Resource

  property	:id, Serial
  property  :post_id, Integer
  property	:user_id, Integer,
  					:length => 16
  property :ip, String,
	  						:format => /^(\d{1,3}\.\d{1,3}\.\d{1,3}\.\d{1,3})?$/,
								:messages => {
									:format => 'You are strange.'
								}
  property	:username, String,
						:required => true,
						:length => 4..16,
						:format => /[a-zA-Z0-9_]/,
						:messages => {
							:presence => 'Username is required',
							:format => 'Username must contains only letters, digits, or underscores.',
							:length => 'Username length must be including betweet 4 and 16 characters.'
						}
  property	:text, Text,
						:required => true,
						:length => 1..65535,
						:messages => {
							:presence => 'Text is required',
							:length => 'Text length must be including betweet 1 and 65535 characters.'
						}
  property	:created_at,	DateTime
  property	:updated_at,	DateTime
  property  :deleted,			ParanoidBoolean
  property  :deleted_at,	ParanoidDateTime
  property  :type,				Discriminator
  
  sanitize :default_mode => :basic
  
  belongs_to :post
end