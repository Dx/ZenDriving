class DriverController < UIViewController

  PLAY_IMAGE = "play.png"
  WARNING1_IMAGE = "warning.png"
  WARNING2_IMAGE = "warning2.png"
  PAUSE_IMAGE = "pause.png"

  BG_PLAY_IMAGE = "bgPlay.png"
  BG_WARNING1_IMAGE = "bgWarning.png"
  BG_WARNING2_IMAGE = "bgWarning2.png"
  BG_PAUSE_IMAGE = "bgPause.png"


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

  def paintScores
    @level_label.text = @temp_score.to_s
    @score_label.text = @total_score.to_s

    animate_to_next_point @level_view, @temp_distance
    animate_to_next_point @score_view, @temp_score
  end

  def getColor(modus, type)
    case modus
      when "Play"
        result = (type=="Mask") ? UIColor.alloc.initWithPatternImage(UIImage.imageNamed(PLAY_IMAGE)) : UIColor.alloc.initWithPatternImage(UIImage.imageNamed(BG_PLAY_IMAGE))
      when "Pause"
        result = (type=="Mask") ? UIColor.alloc.initWithPatternImage(UIImage.imageNamed(PAUSE_IMAGE)) : UIColor.alloc.initWithPatternImage(UIImage.imageNamed(BG_PAUSE_IMAGE))
      when "Warning1"
        result = (type=="Mask") ? UIColor.alloc.initWithPatternImage(UIImage.imageNamed(WARNING1_IMAGE)) : UIColor.alloc.initWithPatternImage(UIImage.imageNamed(BG_WARNING1_IMAGE))
      when "Warning2"
        result = (type=="Mask") ? UIColor.alloc.initWithPatternImage(UIImage.imageNamed(WARNING2_IMAGE)) : UIColor.alloc.initWithPatternImage(UIImage.imageNamed(BG_WARNING2_IMAGE))
      
    end
    result
  end

  def changeColors(level)
    p level.to_s
    if level > 5 && level <= 10
      @car_view.backgroundColor = getColor("Warning1", "Mask")
      @level_view.backgroundColor = getColor("Warning1", "Background")
      @state_icon.image = UIImage.imageNamed("icnWarning.png")
      @state_icon.setHidden(0)
    elsif level > 10
      @car_view.backgroundColor = getColor("Warning2", "Mask")
      @level_view.backgroundColor = getColor("Warning2", "Background")
      @state_icon.image = UIImage.imageNamed("icnWarning.png")
      @state_icon.setHidden(0)
    else
      @car_view.backgroundColor = getColor("Play", "Mask")
      @level_view.backgroundColor = getColor("Play", "Background")
      @state_icon.setHidden(1)
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

      paintScores

    end
  end

  def suscribe_to_accelerator_event

    @reload_observer = App.notification_center.observe "notificationAccelerator" do |notification|

      if @temp_score - notification.object.level < 0
        @temp_score = 0
      else
        @temp_score -= notification.object.level
      end

      paintScores

      @accelerate_label.text = notification.object.level.to_s

      changeColors notification.object.level

    end
  end

  def touchesEnded(touches, withEvent:event)
    if @engine.status == 1
      @engine.pause
      @car_view.backgroundColor = getColor("Pause", "Mask")
      @level_view.backgroundColor = getColor("Pause", "Background")
      @state_icon.setImage = UIImage.imageNamed("icnPause.png")
      @time_label.textColor = UIColor.whiteColor
      @km_label.textColor = UIColor.whiteColor
      @level_label.textColor = UIColor.clearColor
      @km_label.text = @engine.getTimeElapsed
      @time_label.text = @engine.getTotalDistance
    elsif @engine.status == 0
      @engine.start
      @car_view.backgroundColor = getColor("Play", "Mask")
      @level_view.backgroundColor = getColor("Play", "Background")
      @state_icon.image = nil
      @time_label.textColor = UIColor.clearColor
      @km_label.textColor = UIColor.clearColor
      @level_label.textColor = UIColor.whiteColor
    end
  end

  def clickShowMap
    self.presentModalViewController(NVMapViewController.alloc.initWithPoints(@engine.getCoordinates), animated:true)
  end

  def clickStartButton
    changeColors(12)
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
    @level_view.backgroundColor = getColor("Play", "Background")

    self.view.addSubview(@level_view)

    @score_view = UIView.alloc.initWithFrame [[0, 215], [400, 400]]
    @score_view.backgroundColor = UIColor.grayColor

    self.view.addSubview(@score_view)

    @car_view = UIView.alloc.initWithFrame [[0, 0], [480, 320]]
    @car_view.backgroundColor = getColor("Play", "Mask")

    self.view.addSubview(@car_view)

    @accelerate_label = UILabel.new
    @accelerate_label.font = UIFont.systemFontOfSize(15)
    @accelerate_label.text = 'Acel'
    @accelerate_label.textAlignment = UITextAlignmentCenter 
    @accelerate_label.textColor = UIColor.whiteColor
    @accelerate_label.backgroundColor = UIColor.clearColor
    @accelerate_label.frame = [[20, 20], [150, 30]]
    @car_view.addSubview(@accelerate_label)

    @level_label = UILabel.new
    @level_label.font = UIFont.fontWithName("Futura-CondensedExtraBold", size:40)
    @level_label.text = '0'
    @level_label.textAlignment = UITextAlignmentCenter
    @level_label.textColor = UIColor.whiteColor
    @level_label.backgroundColor = UIColor.clearColor
    @level_label.frame = [[160, 150], [150, 34]]
    @car_view.addSubview(@level_label)

    @score_label = UILabel.new
    @score_label.font = UIFont.fontWithName("Futura-CondensedExtraBold", size:40)
    @score_label.text = '0'
    @score_label.textAlignment = UITextAlignmentCenter
    @score_label.textColor = UIColor.whiteColor
    @score_label.backgroundColor = UIColor.clearColor
    @score_label.frame = [[160, 250], [150, 34]]
    @car_view.addSubview(@score_label)

    @km_label = UILabel.new
    @km_label.font = UIFont.fontWithName("Futura-CondensedExtraBold", size:40)
    @km_label.text = '0'
    @km_label.textAlignment = UITextAlignmentCenter
    @km_label.textColor = UIColor.clearColor
    @km_label.backgroundColor = UIColor.clearColor
    @km_label.frame = [[20, 250], [150, 34]]
    @car_view.addSubview(@km_label)

    @time_label = UILabel.new
    @time_label.font = UIFont.fontWithName("Futura-CondensedExtraBold", size:40)
    @time_label.text = '0m'
    @time_label.textAlignment = UITextAlignmentCenter
    @time_label.textColor = UIColor.clearColor
    @time_label.backgroundColor = UIColor.clearColor
    @time_label.frame = [[300, 250], [150, 34]]
    @car_view.addSubview(@time_label)

    @startButton = UIButton.buttonWithType(UIButtonTypeRoundedRect)
    @startButton.frame = [[350, 100],[35, 35]]
    @startButton.addTarget(self, action: :clickStartButton, forControlEvents: UIControlEventTouchUpInside)
    @car_view.addSubview(@startButton)

    @buttonMap = UIButton.buttonWithType(UIButtonTypeRoundedRect)
    @buttonMap.frame = [[10, 25],[20, 20]]
    @buttonMap.addTarget(self, action: :clickShowMap, forControlEvents: UIControlEventTouchUpInside)
    @car_view.addSubview(@buttonMap)

    @state_icon = UIImageView.alloc.initWithFrame([[350, 20], [81, 81]])
    @state_icon.image = UIImage.imageNamed("icnPause.png")
    @state_icon.setHidden(0)
    @car_view.addSubview(@stateIcon)
    
  end

  def shouldAutorotateToInterfaceOrientation(orientation)
    if orientation != UIDeviceOrientationLandscapeLeft
      return false
    else
      return true
    end
  end
end