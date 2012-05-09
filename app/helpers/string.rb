# Helpers (various methods to be used in the controllers).
class String

	# Cuts a string in order to returns a string with the length "limit".
	def cut(limit)
		self.match(%r{^(.{0,#{limit}})})[1]
	end
	
	# Returns the md5 of the string.
	def md5
		Digest::MD5.hexdigest(self)
	end
	
	# Returns true if a string is a number ('1'), false otherwise.
	def numeric?
		self.to_i.to_s == self || self.to_f.to_s == self
	end

end

