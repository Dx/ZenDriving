class MainController < UIViewController

  def viewDidLoad

    configureLabels

    initializeVariables
  	initializeAccelerometer
    initializeTimer

    BW::Location.get(distance_filter: 10, desired_accuracy: :nearest_ten_meters) do |result|
      result[:to].class == CLLocation
      
      add_movement (Snapshot.new (Time.new, result[:to].latitude, result[:to].longitude))
      
    end
  end

  def initializeVariables    
    @xValue = 0
    @yValue = 0
    @fill_value = 50
    @distance_value = 0
    @initialTime = Time.new
    @snapshots = Array.new(4)
  end

  def accelerometer (accelerometer, didAccelerate:acceleration)

    @move_value = (Math.sqrt((@xValue - acceleration.x)**2 + (@yValue - acceleration.y)**2) * 15).to_i
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

  def add_movement(new_snapshot)
    
    if @first_movement.nil?
      @first_movement = new_snapshot      
    else
      if @middle_movement.nil?
        @middle_movement = @first_movement
      elsif !@last_movement.nil?
        @middle_movement = @last_movement
      end
    end

    @last_movement = new_snapshot

  end

  def fireTimer(theTimer)
    calculate
  end

  def calculate
    if !@last_movement.nil?

      @distance_value = haversin_distance(@last_movement.lat, @last_movement.lon,
        @first_movement.lat, @first_movement.lon)
      
      @time_value = @last_movement.time - @first_movement.time
      
      if !@move_value.nil?
        if @fill_value >= 0 && 
          @fill_value = @fill_value - @move_value
        else
          @fill_value = 0
        end
      end

      if !@middle_movement.nil? && !@last_movement.nil?
        if @fill_value < 100  
          @fill_value += haversin_distance(@middle_movement.lat, @middle_movement.lon, @last_movement.lat, @last_movement.lon).to_i
        else
          @fill_value = 100
        end
      end

      showResults

    end    
  end

  def showResults
    @fill.text = @fill_value.to_s
    @distance.text = @distance_value.to_i.to_s
    @time.text = @time_value.to_i.to_s
  end

  def initializeTimer
    NSTimer.scheduledTimerWithTimeInterval (1.0, target:self, selector:'fireTimer:', userInfo:nil, repeats:'YES')
  end

  def initializeAccelerometer
    UIAccelerometer.sharedAccelerometer.setUpdateInterval 0.3
    UIAccelerometer.sharedAccelerometer.setDelegate self
  end

  def configureLabels
    
    margin = 20

    @move_label = UILabel.new
    @move_label.font = UIFont.systemFontOfSize(15)
    @move_label.text = 'Movement'
    @move_label.textAlignment = UITextAlignmentCenter
    @move_label.textColor = UIColor.yellowColor
    @move_label.backgroundColor = UIColor.clearColor
    @move_label.frame = [[margin, 30], [view.frame.size.width - margin * 2, 40]]
    view.addSubview(@move_label)

    @move = UILabel.new
    @move.font = UIFont.systemFontOfSize(20)
    @move.text = 'Move'
    @move.textAlignment = UITextAlignmentCenter
    @move.textColor = UIColor.yellowColor
    @move.backgroundColor = UIColor.clearColor
    @move.frame = [[margin, 50], [view.frame.size.width - margin * 2, 40]]
    view.addSubview(@move)


    @time_label = UILabel.new
    @time_label.font = UIFont.systemFontOfSize(15)
    @time_label.text = 'Time elapsed in seconds'
    @time_label.textAlignment = UITextAlignmentCenter
    @time_label.textColor = UIColor.whiteColor
    @time_label.backgroundColor = UIColor.clearColor
    @time_label.frame = [[margin, 130], [view.frame.size.width - margin * 2, 40]]
    view.addSubview(@time_label)

    @time = UILabel.new
    @time.font = UIFont.systemFontOfSize(20)
    @time.text = 'Time'
    @time.textAlignment = UITextAlignmentCenter
    @time.textColor = UIColor.whiteColor
    @time.backgroundColor = UIColor.clearColor
    @time.frame = [[margin, 150], [view.frame.size.width - margin * 2, 40]]
    view.addSubview(@time)

    @distance_label = UILabel.new
    @distance_label.font = UIFont.systemFontOfSize(15)
    @distance_label.text = 'Distance in meters'
    @distance_label.textAlignment = UITextAlignmentCenter
    @distance_label.textColor = UIColor.redColor
    @distance_label.backgroundColor = UIColor.clearColor
    @distance_label.frame = [[margin, 230], [view.frame.size.width - margin * 2, 40]]
    view.addSubview(@distance_label)

    @distance = UILabel.new
    @distance.font = UIFont.systemFontOfSize(20)
    @distance.text = 'Distance'
    @distance.textAlignment = UITextAlignmentCenter
    @distance.textColor = UIColor.redColor
    @distance.backgroundColor = UIColor.clearColor
    @distance.frame = [[margin, 250], [view.frame.size.width - margin * 2, 40]]
    view.addSubview(@distance)

    @fill_label = UILabel.new
    @fill_label.font = UIFont.systemFontOfSize(15)
    @fill_label.text = 'Score'
    @fill_label.textAlignment = UITextAlignmentCenter
    @fill_label.textColor = UIColor.whiteColor
    @fill_label.backgroundColor = UIColor.clearColor
    @fill_label.frame = [[margin, 330], [view.frame.size.width - margin * 2, 40]]
    view.addSubview(@fill_label)

    @fill = UILabel.new
    @fill.font = UIFont.systemFontOfSize(20)
    @fill.text = 'Fill'
    @fill.textAlignment = UITextAlignmentCenter
    @fill.textColor = UIColor.whiteColor
    @fill.backgroundColor = UIColor.clearColor
    @fill.frame = [[margin, 350], [view.frame.size.width - margin * 2, 40]]
    view.addSubview(@fill)

    @showmap_button = UIButton.buttonWithType(UIButtonTypeRoundedRect)
    @showmap_button.frame = [[67, 420], [180, 20]]
    @showmap_button.addTarget(self, action: :clicked, forControlEvents:UIControlEventTouchUpInside)
    view.addSubview(@showmap_button)
  end

  def clicked
    @mapViewController = MapViewController.alloc.init
    self.presentModalViewController (@mapViewController, animated:true)
  end

end
