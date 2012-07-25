class Snapshot
	attr_reader :x
	attr_reader :y
	attr_reader :lat
	attr_reader :lon

	def initialize(x=0, y=0, lat, lon)
		@x = x
		@y = y
		@lat = lat
		@lon = lon
	end
end