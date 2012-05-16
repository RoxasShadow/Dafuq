class DateTime
	# Converts DateTime in Time.
	def to_time
		return Time.new(self.year, self.month, self.day, self.hour, self.min, self.sec, self.zone)
	end
end
