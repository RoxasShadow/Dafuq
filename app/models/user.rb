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

class User
  include DataMapper::Resource

  property	:id, Serial
  property	:first_ip, String
  property	:last_ip, String
  property  :email, String,
            :unique => true,
            :length => 5..40,
            :format => :email_address,
						:messages => {
							:is_unique => { :field => :username, :error => Status::DENIED, :what => :is_unique },
							:length => { :field => :username, :error => Status::INVALID, :what => :length },
							:format => { :field => :username, :error => Status::INVALID, :what => :format }
						}
  property	:username, String,
            :unique => true,
						:length => 4..16,
						:format => /\A[a-zA-Z0-9_]*\z/,
						:messages => {
							:is_unique => { :field => :username, :error => Status::DENIED, :what => :is_unique },
							:format => { :field => :username, :error => Status::INVALID, :what => :format },
							:length => { :field => :username, :error => Status::INVALID, :what => :length }
						}
  property  :permission_level, Integer, :default => 1
  property	:hashed_password, String
  property	:salt, String
  property  :secret, String,
            :unique => true,
            :length => 10,
						:messages => { # Are these secure?
							:is_unique => { :field => :secret, :error => Status::ERROR, :what => :is_unique },
							:length => { :field => :secret, :error => Status::ERROR, :what => :length }
						}
  property	:created_at,	DateTime
  property	:created_at_in_words, String
  property	:updated_at,	DateTime
  property	:updated_at_in_words, String
  property  :deleted,			ParanoidBoolean
  property  :deleted_at,	ParanoidDateTime
  property	:deleted_at_in_words, String
  property  :type,				Discriminator
  
  has n, :posts
#  has n, :comments

  attr_accessor :password, :password_confirmation
  validates_presence_of :password_confirmation, :unless => Proc.new { |t| t.hashed_password }
  validates_presence_of :password, :unless => Proc.new { |t| t.hashed_password }
  validates_confirmation_of :password
  
  def password=(pass)
    @password = pass
    self.salt = random_string(10) if !self.salt
    self.hashed_password = encrypt(@password, self.salt)
  end
  
  def admin?
    self.permission_level == -1
  end
  
  def site_admin?
    self.id == 1
  end
  
  before :save, :purge
  
  def purge
  	self.username = Rack::Utils.escape_html(self.username)
  end
  
  def created_at_in_words
  	self.created_at && Time.now.to_words(self.created_at.to_time)
  end
  
  def updated_at_in_words
  	self.updated_at && Time.now.to_words(self.updated_at.to_time)
  end
  
  def deleted_at_in_words
  	self.deleted_at && Time.now.to_words(self.deleted_at.to_time)
  end
  
  def User.authenticate(username, pass)
    current_user = User.first(:username => username)
    return nil if current_user.nil?
    return current_user if encrypt(pass, current_user.salt) == current_user.hashed_password
    nil
  end
  
  protected
  def method_missing(m, *args)
    false
  end
  
end
