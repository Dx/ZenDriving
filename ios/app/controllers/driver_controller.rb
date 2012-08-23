class DriverController < UIViewController

  PLAY_IMAGE = "play1.png"
  WARNING1_IMAGE = "warning.png"
  WARNING2_IMAGE = "warning2.png"
  PAUSE_IMAGE = "pause.png"


  def viewDidLoad
    UIApplication.sharedApplication.setStatusBarOrientation(UIInterfaceOrientationLandscapeRight)
    
    configure_ui
    suscribe_to_distance_event
    suscribe_to_accelerator_event

    @engine = Engine.new
  end

  def initialize_scores
    @temp_score = 0
    @total_score = 0
    @temp_distance = 0
  end

  def paint_scores
    @level_label.text = @temp_score.to_s
    @score_label.text = @total_score.to_s

    animate_to_next_point @level_view, @temp_distance
    animate_to_next_point @score_view, @temp_score
  end

  def changeColors(level)
    if level > 5 && level <= 10
      @car_view.backgroundColor = UIColor.alloc.initWithPatternImage(UIImage.imageNamed(WARNING1_IMAGE))
    elsif level > 10
      @car_view.backgroundColor = UIColor.alloc.initWithPatternImage(UIImage.imageNamed(WARNING2_IMAGE))
    else
      @car_view.backgroundColor = UIColor.alloc.initWithPatternImage(UIImage.imageNamed(PLAY_IMAGE))
    end
  end

  def suscribe_to_distance_event
    @foreground_observer = App.notification_center.observe "notificationLocator" do |notification|

      if @temp_distance + notification.object.distance.to_i <= 100
        @temp_distance += notification.object.distance.to_i
        @temp_score += notification.object.distance.to_i
      else        
        @total_score += (@temp_score > 100) ? 100 : @temp_score
        animate_to_next_point @level_view, 100
        @temp_distance = 0
        @temp_score = 0
      end

      paint_scores

    end
  end

  def suscribe_to_accelerator_event

    @reload_observer = App.notification_center.observe "notificationAccelerator" do |notification|

      if @temp_score - notification.object.level < 0
        @temp_score = 0
      else
        @temp_score -= notification.object.level
      end

      paint_scores

      @accelerate_label.text = notification.object.level.to_s

      changeColors notification.object.level

    end
  end

  def touchesEnded(touches, withEvent:event)
    if @engine.status == 1
      @engine.pause
      @car_view.backgroundColor = UIColor.alloc.initWithPatternImage(UIImage.imageNamed(PAUSE_IMAGE))
      @time_label.textColor = UIColor.whiteColor
      @km_label.textColor = UIColor.whiteColor
      @level_label.textColor = UIColor.clearColor
      @km_label.text = @engine.getTimeElapsed
      @time_label.text = @engine.getTotalDistance
    elsif @engine.status == 0
      @engine.start
      @car_view.backgroundColor = UIColor.alloc.initWithPatternImage(UIImage.imageNamed(PLAY_IMAGE))
      @time_label.textColor = UIColor.clearColor
      @km_label.textColor = UIColor.clearColor
      @level_label.textColor = UIColor.whiteColor
    end
  end

  def clickShowMap
    self.presentModalViewController(NVMapViewController.alloc.initWithPoints(@engine.getCoordinates), animated:true)
  end

  def clickStartButton
    if @engine.status == -1
      initialize_scores
      @engine.start
    else
      @engine.stop

      # Show score view
    end
  end

  def animate_to_next_point(view, percentage)
    
    position = (((100-percentage) * 110) / 100) + 105

    UIView.animateWithDuration(0.3, delay: 0.3, options: UIViewAnimationOptionCurveLinear, 
      animations:lambda{
          view.frame = [[0,position], [400, 400]]
        },
      completion:lambda{|finished| 
          # self.animate_to_next_point
        }
    )
    # 215 = 0 105 = 100
    #  110 = 100
    #    ? = x
  end
  
  def configure_ui
    self.view.backgroundColor = UIColor.blackColor

    @level_view = UIView.alloc.initWithFrame [[0, 215], [400, 400]]
    @level_view.backgroundColor = UIColor.yellowColor

    self.view.addSubview(@level_view)

    @score_view = UIView.alloc.initWithFrame [[0, 215], [400, 400]]
    @score_view.backgroundColor = UIColor.blueColor

    self.view.addSubview(@score_view)

    @car_view = UIView.alloc.initWithFrame [[0, 0], [480, 320]]
    @car_view.backgroundColor = UIColor.alloc.initWithPatternImage(UIImage.imageNamed(PLAY_IMAGE))

    self.view.addSubview(@car_view)

    @accelerate_label = UILabel.new
    @accelerate_label.font = UIFont.systemFontOfSize(15)
    @accelerate_label.text = 'Acel'
    @accelerate_label.textAlignment = UITextAlignmentCenter 
    @accelerate_label.textColor = UIColor.whiteColor
    @accelerate_label.backgroundColor = UIColor.clearColor
    @accelerate_label.frame = [[20, 20], [150, 30]]
    self.view.addSubview(@accelerate_label)

    @level_label = UILabel.new
    @level_label.font = UIFont.fontWithName("Futura-CondensedExtraBold", size:40)
    @level_label.text = '0'
    @level_label.textAlignment = UITextAlignmentCenter
    @level_label.textColor = UIColor.whiteColor
    @level_label.backgroundColor = UIColor.clearColor
    @level_label.frame = [[160, 150], [150, 34]]
    self.view.addSubview(@level_label)

    @score_label = UILabel.new
    @score_label.font = UIFont.fontWithName("Futura-CondensedExtraBold", size:40)
    @score_label.text = '0'
    @score_label.textAlignment = UITextAlignmentCenter
    @score_label.textColor = UIColor.whiteColor
    @score_label.backgroundColor = UIColor.clearColor
    @score_label.frame = [[160, 250], [150, 34]]
    self.view.addSubview(@score_label)

    @km_label = UILabel.new
    @km_label.font = UIFont.fontWithName("Futura-CondensedExtraBold", size:40)
    @km_label.text = '0'
    @km_label.textAlignment = UITextAlignmentCenter
    @km_label.textColor = UIColor.clearColor
    @km_label.backgroundColor = UIColor.clearColor
    @km_label.frame = [[20, 250], [150, 34]]
    self.view.addSubview(@km_label)

    @time_label = UILabel.new
    @time_label.font = UIFont.fontWithName("Futura-CondensedExtraBold", size:40)
    @time_label.text = '0m'
    @time_label.textAlignment = UITextAlignmentCenter
    @time_label.textColor = UIColor.clearColor
    @time_label.backgroundColor = UIColor.clearColor
    @time_label.frame = [[300, 250], [150, 34]]
    self.view.addSubview(@time_label)

    @startButton = UIButton.buttonWithType(UIButtonTypeRoundedRect)
    @startButton.frame = [[350, 25],[45, 35]]
    @startButton.addTarget(self, action: :clickStartButton, forControlEvents: UIControlEventTouchUpInside)
    self.view.addSubview(@startButton)

    @buttonMap = UIButton.buttonWithType(UIButtonTypeRoundedRect)
    @buttonMap.frame = [[10, 25],[20, 20]]

    @buttonMap.addTarget(self, action: :clickShowMap, forControlEvents: UIControlEventTouchUpInside)

    self.view.addSubview(@buttonMap)
  end

  def shouldAutorotateToInterfaceOrientation(orientation)
    if orientation != UIDeviceOrientationLandscapeLeft
      return false
    else
      return true
    end
  end
end