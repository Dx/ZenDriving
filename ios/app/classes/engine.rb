class Engine

  def status; @status; end

  def initialize
    initializeValues
    @coordinates = Array.new
  end

  def initializeValues
    @distance = 0.0 
    @total_distance = 0.0 
    @initial_x_value = 0
    @initial_y_value = 0
    @status = -1
    @initial_time = Time.new
    @simulate_num = 0
  end

  def simulateAccel
    accelerate(0.55, 0.55)
    accelerate(0, 0)
  end

  def simulateLocator
    @simulate_num = @simulate_num + 1
    movement = @simulate_num * 0.000000003
    p @simulate_num
    p movement
    p 37.7858276367188 + movement + 10
    locate(37.7858276367188 + movement, -122.406402587891 + movement, 37.7858276367191 + movement, -122.406402587893 + movement)
  end

	def start
    if @status != 0
      initializeValues
    end
    initializeAccelerometer
    initializeLocator
    @status = 1    
	end  

	def stop    
    @status = -1
    @accelerometer = nil
    @final_time = Time.new
	end

  def pause
    @status = 0    
    @accelerometer = nil
  end

  def getCoordinates
    @coordinates
  end

  def getTimeElapsed
    @final_time = Time.new
    ((@final_time - @initial_time)/60).to_i.to_s
  end

  def getTotalDistance
    (@total_distance/1000).to_s
  end

  def notificateLocator(locatorNotif)
    App.notification_center.post("notificationLocator", locatorNotif)
  end

  def notificateAccelerator(acceleratorNotif)
    App.notification_center.post("notificationAccelerator", acceleratorNotif)    
  end

  def initializeLocator
    BW::Location.get(distance_filter: 10, desired_accuracy: :nearest_ten_meters) do |result|
      result[:to].class == CLLocation
      result[:from].class == CLLocation

      if result[:from] != nil && result[:to] != nil
        locate(result[:from].latitude, result[:from].longitude, result[:to].latitude, result[:to].longitude)
      end

      if @status != 1
        break
      end
    end
  end

  def locate(initialLatitude, initialLongitude, finalLatitude, finalLongitude)
    if @initial_coordinate == nil
      @initial_coordinate = CLLocationCoordinate2D.new(initialLatitude, initialLongitude)
      @coordinates << @initial_coordinate
    end

    p "posicion #{initialLatitude}, #{initialLongitude}, #{finalLatitude}, #{finalLongitude}"
    
    @distance = haversin_distance(finalLatitude, finalLongitude, initialLatitude, initialLongitude)
    @total_distance += @distance
    coordinate = CLLocationCoordinate2D.new(finalLatitude, finalLongitude)

    movement_notification = MovementNotification.new(@distance, coordinate)
    @coordinates << coordinate

    self.notificateLocator(movement_notification)
  end

	def initializeAccelerometer
    @accelerometer = UIAccelerometer.sharedAccelerometer.setUpdateInterval 0.3
    @accelerometer.setDelegate self
  end

  def accelerometer (accelerometer, didAccelerate:acceleration)
    accelerate(acceleration.x, acceleration.y)    
  end

  def accelerate(x, y)
    if @initial_x_value == 0
      @initial_x_value = x
      @initial_y_value = y
    end
    
    move_x_value = ((@initial_x_value - x)*20.0).abs.to_i
    move_y_value = ((@initial_y_value - y)*20.0).abs.to_i 

    notif = AcceleratorNotification.new(move_x_value + move_y_value)

    if @status == 1
      self.notificateAccelerator(notif)
    end
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