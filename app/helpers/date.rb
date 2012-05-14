class Date	
	def to_datetime
		return DateTime.new(self.year, self.month, self.day, self.hour, self.min, self.sec, Rational(self.gmt_offset / 3600, 24))
	end
end
