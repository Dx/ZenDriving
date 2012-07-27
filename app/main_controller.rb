class MainController < UIViewController

  def viewDidLoad

    configureLabels

    initializeVariables
  	initializeAccelerometer
    initializeLocator

    BW::Location.get(distance_filter: 1, desired_accuracy: :nearest_ten_meters) do |result|
      result[:to].class == CLLocation
      
      @snapshots << Snapshot.new (Time.new, result[:to].latitude, result[:to].longitude)
      
      calculate

      @fill.text = @fill_value.to_s
      @distance.text = @distance_value.to_s
      @time.text = @time_value.to_s
    end
  end

  def initializeVariables
    @xValue = 0
    @yValue = 0
    @fill_value = 50
    @distance_value = 0
    @initialTime = Time.new
    @snapshots = Array.new
  end

  def accelerometer (accelerometer, didAccelerate:acceleration)

    @move_value = Math.sqrt((@xValue - acceleration.x)**2 + (@yValue - acceleration.y)**2)
    @move.text = @move_value.to_s

    @xValue << acceleration.x
    @yValue << acceleration.y
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

  def calculate
    if @snapshots.size > 0
      p "#{@snapshots[@snapshots.size-1].lat} ultima latitud"
      p "#{@snapshots[@snapshots.size-1].lon} ultima longitud"
      p "#{@snapshots[0].lat} primera latitud"
      p "#{@snapshots[0].lon} primera longitud"

      @distance_value = haversin_distance(@snapshots[@snapshots.size-1].lat, @snapshots[@snapshots.size-1].lon,
        @snapshots[0].lat, @snapshots[0].lon)
      
      @time_value = @snapshots[@snapshots.size-1].time - @snapshots[0].time
      
      if @fill_value >= 0 && @move_value != nil

        @fill_value = @fill_value - (@move_value * 20).to_i
      end

      if @fill_value < 50
        @fill_value += 1
      end
    end    
  end

  def initializeLocator
  end

  def initializeAccelerometer
    UIAccelerometer.sharedAccelerometer.setUpdateInterval 0.3
    UIAccelerometer.sharedAccelerometer.setDelegate self
  end

  def configureLabels
    
    margin = 20

    @move = UILabel.new
    @move.font = UIFont.systemFontOfSize(20)
    @move.text = 'Move'
    @move.textAlignment = UITextAlignmentCenter
    @move.textColor = UIColor.yellowColor
    @move.backgroundColor = UIColor.clearColor
    @move.frame = [[margin, 50], [view.frame.size.width - margin * 2, 40]]
    view.addSubview(@move)

    @time = UILabel.new
    @time.font = UIFont.systemFontOfSize(20)
    @time.text = 'Time'
    @time.textAlignment = UITextAlignmentCenter
    @time.textColor = UIColor.whiteColor
    @time.backgroundColor = UIColor.clearColor
    @time.frame = [[margin, 150], [view.frame.size.width - margin * 2, 40]]
    view.addSubview(@time)

    @distance = UILabel.new
    @distance.font = UIFont.systemFontOfSize(20)
    @distance.text = 'Distance'
    @distance.textAlignment = UITextAlignmentCenter
    @distance.textColor = UIColor.redColor
    @distance.backgroundColor = UIColor.clearColor
    @distance.frame = [[margin, 250], [view.frame.size.width - margin * 2, 40]]
    view.addSubview(@distance)

    @fill = UILabel.new
    @fill.font = UIFont.systemFontOfSize(20)
    @fill.text = 'Fill'
    @fill.textAlignment = UITextAlignmentCenter
    @fill.textColor = UIColor.blueColor
    @fill.backgroundColor = UIColor.clearColor
    @fill.frame = [[margin, 350], [view.frame.size.width - margin * 2, 40]]
    view.addSubview(@fill)
  end

end
