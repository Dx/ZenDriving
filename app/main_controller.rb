class MainController < UIViewController

  def viewDidLoad

  	UIAccelerometer.sharedAccelerometer.setUpdateInterval 0.3
		UIAccelerometer.sharedAccelerometer.setDelegate self

    margin = 20

    @state = UILabel.new
    @state.font = UIFont.systemFontOfSize(10)
    @state.text = 'Tap to start'
    @state.textAlignment = UITextAlignmentCenter
    @state.textColor = UIColor.whiteColor
    @state.backgroundColor = UIColor.clearColor
    @state.frame = [[margin, 200], [view.frame.size.width - margin * 2, 40]]
    view.addSubview(@state)

    @location = UILabel.new
    @location.font = UIFont.systemFontOfSize(10)
    @location.text = 'Location'
    @location.textAlignment = UITextAlignmentCenter
    @location.textColor = UIColor.redColor
    @location.backgroundColor = UIColor.clearColor
    @location.frame = [[margin, 300], [view.frame.size.width - margin * 2, 40]]
    view.addSubview(@location)
    
    BW::Location.get(distance_filter: 10, desired_accuracy: :nearest_ten_meters) do |result|
      result[:to].class == CLLocation
      result[:from].class == CLLocation
      @location.text = "Lat #{result[:to].latitude}, Long #{result[:to].longitude}"
    end

  end

  def accelerometer (accelerometer, didAccelerate:acceleration)
    valueX = acceleration.x*30.0;
    valueY = acceleration.y*30.0;
    @state.text = "Pos x #{valueX.to_i} Pos y #{valueY.to_i}"
  end

  # def locationUpdate (location)
  #   @location.text = location.description
  # end
 
  # def locationError (error)
  #   @location.text = error.description
  # end

end
