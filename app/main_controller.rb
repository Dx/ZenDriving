class MainController < UIViewController

  def viewDidLoad

    configureLabels

    initializeVariables
  	initializeAccelerometer
    initializeLocator
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

    @xValue << acceleration.x*30.0
    @yValue << acceleration.y*30.0
  end

  def calculate
    if @snapshots.size > 0
      @distance_value = haversine_distance(@snapshots[@snapshots.size-1].lat, @snapshots[@snapshots.size-1].lon,
        @snapshots[0].lat, @snapshots[0].lon)
      
      @time_value = @snapshots[@snapshots.size-1].time - @snapshots[0].time
      
      if @fill_value >= 0      
        @fill_value = @fill_value - (@move_value * 20).to_i
      end

      if @fill_value < 50
        @fill_value += 1
      end
    else
      0  
    end    
  end

  def initializeLocator
    BW::Location.get(distance_filter: 1, desired_accuracy: :best) do |result|
      result[:to].class == CLLocation
      
      if @valueX != nil 
        @snapshots << Snapshot.new (Time.new, result[:to].latitude, result[:to].longitude)
      end

      calculate

      @fill.text = @fill_value.to_s
      @distance.text = @distance_value.to_s
      @time.text = @time_value.to_s
    end
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
