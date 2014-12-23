class PrivateRoom < Room

	def create_name
		self.name = ""
		self.members.map{|m| self.name += m.id.to_s}
	end

end