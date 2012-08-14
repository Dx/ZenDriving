class Engine
	def initialize

	end

	def start
    @isStarted = TRUE    
    initializeAccelerometer
    initializeLocator
	end

	def stop
    @isStarted = FALSE
	end

  def notificateLocator(locatorNotif)

    NSNotificationCenter.defaultCenter.postNotificationName("notificateLocator",
       object:locatorNotif)

  end

  def notificateAccelerator(acceleratorNotif)

    NSNotificationCenter.defaultCenter.postNotificationName("notificateAccelerator",
       object:acceleratorNotif)

  end

  def initializeLocator
    BW::Location.get(distance_filter: 10, desired_accuracy: :nearest_ten_meters) do |result|
      result[:to].class == CLLocation
      result[:from].class == CLLocation

      if @initial_coordinate == nil
        @initial_coordinate = CLLocationCoordinate2D.new(result[:to].latitude, result[:to].longitude)
      end

      @distance += harvesin_distance(result[:to].latitude, result[:to].longitude, result[:from].latitude, result[:from].longitude)

      coordinate = CLLocationCoordinate2D.new(result[:to].latitude, result[:to].longitude)

      movement_notification = MovementNotification.new(@distance, coordinate)

      notificateLocator(movement_notification)
      
      if !@is_started
        break
      end
    end
  end

	def initializeAccelerometer
    UIAccelerometer.sharedAccelerometer.setUpdateInterval 0.3
    UIAccelerometer.sharedAccelerometer.setDelegate self    
  end

  def accelerometer (accelerometer, didAccelerate:acceleration)

    if @initial_x_value == 0
      @initial_x_value = acceleration.x
      @initial_y_value = acceleration.y
    end
    
    @move_x_value = ((@initial_x_value - acceleration.x)*100.0).abs.to_i
    @move_y_value = ((@initial_y_value - acceleration.y)*100.0).abs.to_i 

    accelerometer_notification = @move_x_value + @move_y_value

    notificateAccelerator(accelerometer_notification)
  end

  def haversin_distance( lat1, lon1, lat2, lon2 )

    rad_per_deg = 0.017453293  #  PI/180
    # the great circle distance d will be in whatever units R is in
    rmiles = 3956           # radius of the great circle in miles
    rkm = 6371              # radius in kilometers...some algorithms use 6367
    rfeet = rmiles * 5282   # radius in feet
    rmeters = rkm * 1000    # radius in meters

    dlon = lon2 - lon1
    dlat = lat2 - lat1
    dlon_rad = dlon * rad_per_deg
    dlat_rad = dlat * rad_per_deg
    lat1_rad = lat1 * rad_per_deg
    lon1_rad = lon1 * rad_per_deg

    lat2_rad = lat2 * rad_per_deg
    lon2_rad = lon2 * rad_per_deg
       
    a = (Math.sin(dlat_rad/2))**2 + Math.cos(lat1_rad) * Math.cos(lat2_rad) * (Math.sin(dlon_rad/2))**2
    c = 2 * Math.atan2( Math.sqrt(a), Math.sqrt(1-a))
     
    dMi = rmiles * c          # delta between the two points in miles
    dKm = rkm * c             # delta in kilometers
    dFeet = rfeet * c         # delta in feet
    dMeters = rmeters * c     # delta in meters
    dMeters
  end
end