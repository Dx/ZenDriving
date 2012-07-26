class Snapshot
	attr_reader :time
	attr_reader :lat
	attr_reader :lon

	def initialize(time, lat, lon)
		@time = time
		@lat = lat
		@lon = lon
	end
end