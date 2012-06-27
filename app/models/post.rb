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

class Post
  include DataMapper::Resource

  property	:id, Serial
  property	:to, String
  property	:text, Text,
						:required => true,
						:messages => {
							:presence => { :field => :text, :error => Status::MISSING, :what => :presence }
						}
  property	:created_at,	DateTime
  property	:created_at_in_words, String
  property	:updated_at,	DateTime
  property	:updated_at_in_words, String
  property  :deleted,			ParanoidBoolean
  property  :deleted_at,	ParanoidDateTime
  property	:deleted_at_in_words, String
  property  :type,				Discriminator
  
  belongs_to :user
#  has n, :comments, :constraint => :destroy
  
  before :save, :purge
  
  def purge
  	self.text = Rack::Utils.escape_html(self.text)
  end
  
  def created_at_in_words
  	self.created_at && Time.now.to_words(self.created_at.to_time)
  end
  
  def updated_at_in_words
  	self.updated_at  && Time.now.to_words(self.updated_at.to_time)
  end
  
  def deleted_at_in_words
  	self.deleted_at && Time.now.to_words(self.deleted_at.to_time)
  end
  
  protected
  def method_missing(m, *args)
    false
  end
  
end
