# encoding: utf-8
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

# Database model. Explains what the posts are.
class Post
  include DataMapper::Resource

  property	:id, Serial
  property	:user_id, String
  property	:ip, String,
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
  property	:created_at_in_words, String
  property	:updated_at,	DateTime
  property	:updated_at_in_words, String
  property  :deleted,			ParanoidBoolean
  property  :deleted_at,	ParanoidDateTime
  property	:deleted_at_in_words, String
  property  :up,					Integer,
  					:default => 0
  property  :type,				Discriminator
  
  has n, :comments, :constraint => :destroy
  
  before :save, :purge
  
  def purge
  	self.username = Rack::Utils.escape_html(self.username)
  	self.text = Rack::Utils.escape_html(self.text)
  end
  
  def created_at_in_words
  	self.created_at == nil ? nil : Time.now.to_words(self.created_at.to_time)
  end
  
  def updated_at_in_words
  	self.updated_at == nil ? nil : Time.now.to_words(self.updated_at.to_time)
  end
  
  def deleted_at_in_words
  	self.deleted_at == nil ? nil : Time.now.to_words(self.deleted_at.to_time)
  end
  
end
