
# def haversine_distance( lat1, lon1, lat2, lon2 )

# 	rad_per_deg = 0.017453293  #  PI/180
# 	# the great circle distance d will be in whatever units R is in
# 	rmiles = 3956           # radius of the great circle in miles
# 	rkm = 6371              # radius in kilometers...some algorithms use 6367
# 	rfeet = rmiles * 5282   # radius in feet
# 	rmeters = rkm * 1000    # radius in meters

# 	dlon = lon2 - lon1
# 	dlat = lat2 - lat1
# 	dlon_rad = dlon * rad_per_deg
# 	dlat_rad = dlat * rad_per_deg
# 	lat1_rad = lat1 * rad_per_deg
# 	lon1_rad = lon1 * rad_per_deg

# 	lat2_rad = lat2 * rad_per_deg
# 	lon2_rad = lon2 * rad_per_deg
	 	 
# 	a = (Math.sin(dlat_rad/2))**2 + Math.cos(lat1_rad) * Math.cos(lat2_rad) * (Math.sin(dlon_rad/2))**2
# 	c = 2 * Math.atan2( Math.sqrt(a), Math.sqrt(1-a))
	 
# 	dMi = rmiles * c          # delta between the two points in miles
# 	dKm = rkm * c             # delta in kilometers
# 	dFeet = rfeet * c         # delta in feet
# 	dMeters = rmeters * c     # delta in meters
	 
# 	@distances = Hash.new
# 	@distances["mi"] = dMi
# 	@distances["km"] = dKm
# 	@distances["ft"] = dFeet
# 	@distances["m"] = dMeters

# 	dMeters
# end
 
# def test_haversine
 
# 	lon1 = -104.88544
# 	lat1 = 39.06546
	 
# 	lon2 = -104.80
# 	lat2 = lat1
	 
# 	haversine_distance( lat1, lon1, lat2, lon2 )
	 
# 	if ( @distances['km'].to_s.match(/7\.376*/) != nil )
# 	puts "Test: Success"
# 	else
# 	puts "Test: Failed"
# 	end
 
# end
 
# # test_haversine