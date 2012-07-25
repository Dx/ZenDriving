class MainController < UIViewController

  def viewDidLoad

  	UIAccelerometer.sharedAccelerometer.setUpdateInterval 0.5
		UIAccelerometer.sharedAccelerometer.setDelegate self

    margin = 20

    @state = UILabel.new
    @state.font = UIFont.systemFontOfSize(10)
    @state.text = 'Accelerometer'
    @state.textAlignment = UITextAlignmentCenter
    @state.textColor = UIColor.whiteColor
    @state.backgroundColor = UIColor.clearColor
    @state.frame = [[margin, 150], [view.frame.size.width - margin * 2, 40]]
    view.addSubview(@state)

    @location = UILabel.new
    @location.font = UIFont.systemFontOfSize(10)
    @location.text = 'Location'
    @location.textAlignment = UITextAlignmentCenter
    @location.textColor = UIColor.redColor
    @location.backgroundColor = UIColor.clearColor
    @location.frame = [[margin, 250], [view.frame.size.width - margin * 2, 40]]
    view.addSubview(@location)

    @score = UILabel.new
    @score.font = UIFont.systemFontOfSize(20)
    @score.text = 'Score'
    @score.textAlignment = UITextAlignmentCenter
    @score.textColor = UIColor.blueColor
    @score.backgroundColor = UIColor.clearColor
    @score.frame = [[margin, 350], [view.frame.size.width - margin * 2, 40]]
    view.addSubview(@score)

    @snapshots = Array.new
    @valueX = 0    
    @valueY = 0

    BW::Location.get(distance_filter: 10, desired_accuracy: :best) do |result|
      result[:to].class == CLLocation
      @location.text = "Lat #{result[:to].latitude}, Long #{result[:to].longitude}"

      if @valueX != nil 
        @snapshots << Snapshot.new (@valueX, @valueY, result[:to].latitude, result[:to].longitude)
        @score.text = calculate.to_s
      end
    end

  end

  def accelerometer (accelerometer, didAccelerate:acceleration)
    @valueX = acceleration.x*30.0;
    @valueY = acceleration.y*30.0;
    @state.text = "Pos x #{@valueX.to_i} Pos y #{@valueY.to_i}"    
  end

  def calculate
    if @snapshots.size > 0
      totalx = 0
      totaly = 0
      dlat = @snapshots[@snapshots.size-1].lat - @snapshots[0].lat  
      dlon = @snapshots[@snapshots.size-1].lon - @snapshots[0].lon
      distance = Math.sqrt(dlat**2 + dlon**2)

      @snapshots.each do |s|
        totalx += s.x.abs
        totaly += s.y.abs
      end

      average_x = totalx / @snapshots.size
      average_y = totaly / @snapshots.size

      acelerometer_score = (@snapshots[0].x.abs - average_x) * (@snapshots[0].y.abs - average_y)
      acelerometer_score * distance
    else
      0  
    end
    
  end

end
