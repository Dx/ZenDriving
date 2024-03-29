class DriverController < UIViewController

  PLAY_IMAGE = "play.png"
  WARNING1_IMAGE = "warning.png"
  WARNING2_IMAGE = "warning2.png"
  PAUSE_IMAGE = "pause.png"

  BG_PLAY_IMAGE = "bgPlay.png"
  BG_WARNING1_IMAGE = "bgWarning.png"
  BG_WARNING2_IMAGE = "bgWarning2.png"
  BG_PAUSE_IMAGE = "bgPause.png"

  ICON_WARNING = "icnWarning.png"

  def viewDidLoad
    configure_ui
    suscribe_to_distance_event
    suscribe_to_accelerator_event

    @engine = Engine.new

    initialize_scores
    @engine.start
  end

  def tempScore
    @temp_score
  end

  def totalScore
    @total_score
  end

  def tempDistance
    @temp_distance
  end

  def bestScore
    @bestScore
  end

  def initialize_scores
    @temp_score = 0
    @total_score = 0
    @temp_distance = 0
    @best_score = 0    
  end

  def paintScores
    @level_label.text = @temp_score.to_s
    @score_label.text = @total_score.to_s
    animateLabel(@score_label, @total_score.to_s)

    animate_to_next_point @level_view, @temp_distance
    animate_to_next_point @score_view, @temp_score
  end

  def showTempScore    
    @best_score = (@temp_score > @best_score) ? @temp_score : @best_score
    @best_label.text = @best_score.to_s    
  end

  def getImage(image)
    UIColor.alloc.initWithPatternImage(UIImage.imageNamed(image))
  end

  def changeColors(level)
    p level.to_s
    if level > 5 && level <= 10
      @car_view.backgroundColor = getImage(WARNING1_IMAGE)
      self.view.backgroundColor = getImage(BG_WARNING1_IMAGE)
      @state_icon.backgroundColor = getImage(ICON_WARNING)
    elsif level > 10
      @car_view.backgroundColor = getImage(WARNING2_IMAGE)
      self.view.backgroundColor = getImage(BG_WARNING2_IMAGE)
      @state_icon.backgroundColor = getImage(ICON_WARNING)
    else
      @car_view.backgroundColor = getImage(PLAY_IMAGE)
      self.view.backgroundColor = getImage(BG_PLAY_IMAGE)
      @state_icon.backgroundColor = UIColor.clearColor
      @state_icon.setHidden(1)
    end
  end

  def suscribe_to_distance_event
    @foreground_observer = App.notification_center.observe "notificationLocator" do |notification|

      if @temp_distance + notification.object.distance.to_i <= 100
        @temp_distance += notification.object.distance.to_i
        @temp_score += notification.object.distance.to_i
        paintScores
      else        
        @total_score += (@temp_score > 100) ? 100 : @temp_score
        animateLabel(@level_label, @temp_score.to_s)
        showTempScore
        animate_to_next_point @level_view, 100
        @temp_distance = 0
        @temp_score = 0
      end
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
      @car_view.backgroundColor = getImage(PAUSE_IMAGE)
      self.view.backgroundColor = getImage(BG_PAUSE_IMAGE)
      @state_icon.backgroundColor = getImage("icnPause.png")

      @time_title_label.textColor = UIColor.whiteColor
      @time_label.textColor = UIColor.whiteColor

      @km_title_label.textColor = UIColor.whiteColor
      @km_label.textColor = UIColor.whiteColor

      @score_title_label.textColor = UIColor.whiteColor
      @best_title_label.textColor = UIColor.whiteColor

      @level_label.textColor = UIColor.clearColor
      @km_label.text = @engine.getTotalDistance
      @time_label.text = @engine.getTimeElapsed

    elsif @engine.status == 0
      @engine.start
      @car_view.backgroundColor = getImage(PLAY_IMAGE)
      @state_icon.backgroundColor = UIColor.clearColor
      
      @time_label.textColor = UIColor.clearColor
      @time_title_label.textColor = UIColor.clearColor

      @km_label.textColor = UIColor.clearColor
      @km_title_label.textColor = UIColor.clearColor
      @score_title_label.textColor = UIColor.clearColor
      @best_title_label.textColor = UIColor.clearColor

      @level_label.textColor = UIColor.whiteColor
    end
  end

  def clickShowMap
    @engine.stop

    points = @engine.getCoordinates
    self.presentModalViewController(NVMapViewController.alloc.initWithPoints(points), animated:true)

    @mapView = MapViewController.alloc.init
    @mapView.points = points
    @mapView.min = @engine.getTimeElapsed
    @mapView.km = @engine.getTotalDistance
    @mapView.pts = @total_score.to_s
    self.presentModalViewController(@mapView, animated:true)
  end

  def animate_to_next_point(view, percentage)
    
    position = (((100-percentage) * 110) / 100) + 105

    UIView.animateWithDuration(0.3, delay: 0.3, options: UIViewAnimationOptionCurveLinear, 
      animations:lambda{
          view.frame = [[0,position], [400, 400]]
        },
      completion:lambda{|finished|           
        }
    )
    # 215 = 0 105 = 100
    #  110 = 100
    #    ? = x
  end

  def animateLabel(label, label_text)
    
    label.text = label_text

    UIView.animateWithDuration(0.5, delay:0.3, options:UIViewAnimationOptionCurveLinear, animations:lambda{
        label.transform = CGAffineTransformMakeScale( 3.0, 3.0 )
        # label.textColor = UIColor.whiteColor
      }, 
      completion:lambda{|finished|
        # label.textColor = UIColor.clearColor
        label.transform = CGAffineTransformMakeScale( 1.0, 1.0 );
        playSound
      })
  end

  def playSound
    local_file = File.join(NSBundle.mainBundle.resourcePath, 'poing.mp3')

    BW::Media.play_modal(NSURL.fileURLWithPath(local_file))
  end

  def clickSimulAcel
    # @engine.simulateAccel
    self.animateLabel(@accelerate_label, "hola")
    playSound
  end

  def clickSimulLoc
    @engine.simulateLocator
  end
  
  def configure_ui
    self.view.backgroundColor = getImage(BG_PLAY_IMAGE)

    @level_view = UIView.alloc.initWithFrame [[0, 215], [400, 400]]
    @level_view.backgroundColor = UIColor.lightGrayColor

    self.view.addSubview(@level_view)

    @score_view = UIView.alloc.initWithFrame [[0, 215], [400, 400]]
    @score_view.backgroundColor = UIColor.blackColor

    self.view.addSubview(@score_view)

    @car_view = UIView.alloc.initWithFrame [[0, 0], [480, 320]]
    @car_view.backgroundColor = getImage(PLAY_IMAGE)

    self.view.addSubview(@car_view)

    @accelerate_label = UILabel.new
    @accelerate_label.font = UIFont.systemFontOfSize(10)
    @accelerate_label.text = ''
    @accelerate_label.textAlignment = UITextAlignmentCenter 
    @accelerate_label.textColor = UIColor.whiteColor
    @accelerate_label.backgroundColor = UIColor.clearColor
    @accelerate_label.frame = [[20, 20], [150, 30]]
    @car_view.addSubview(@accelerate_label)

    @best_label = UILabel.new
    @best_label.font = UIFont.fontWithName("Futura-CondensedExtraBold", size:40)
    @best_label.text = '0'
    @best_label.textAlignment = UITextAlignmentCenter 
    @best_label.textColor = UIColor.whiteColor
    @best_label.backgroundColor = UIColor.clearColor
    @best_label.frame = [[160, 45], [150, 34]]
    @car_view.addSubview(@best_label)

    @best_title_label = UILabel.new
    @best_title_label.font = UIFont.fontWithName("Futura-CondensedExtraBold", size:16)
    @best_title_label.text = 'BEST'
    @best_title_label.textAlignment = UITextAlignmentCenter 
    @best_title_label.textColor = UIColor.clearColor
    @best_title_label.backgroundColor = UIColor.clearColor
    @best_title_label.frame = [[160, 15], [150, 34]]
    @car_view.addSubview(@best_title_label)

    @level_label = UILabel.new
    @level_label.font = UIFont.fontWithName("Futura-CondensedExtraBold", size:40)
    @level_label.text = '0'
    @level_label.textAlignment = UITextAlignmentCenter
    @level_label.textColor = UIColor.whiteColor
    @level_label.backgroundColor = UIColor.clearColor
    @level_label.frame = [[160, 140], [150, 34]]
    @car_view.addSubview(@level_label)

    @km_label = UILabel.new
    @km_label.font = UIFont.fontWithName("Futura-CondensedExtraBold", size:40)
    @km_label.text = '0'
    @km_label.textAlignment = UITextAlignmentCenter
    @km_label.textColor = UIColor.clearColor
    @km_label.backgroundColor = UIColor.clearColor
    @km_label.frame = [[20, 220], [150, 34]]
    @car_view.addSubview(@km_label)

    @km_title_label = UILabel.new
    @km_title_label.font = UIFont.fontWithName("Futura-CondensedExtraBold", size:16)
    @km_title_label.text = 'KM'
    @km_title_label.textAlignment = UITextAlignmentCenter
    @km_title_label.textColor = UIColor.clearColor
    @km_title_label.backgroundColor = UIColor.clearColor
    @km_title_label.frame = [[20, 250], [150, 34]]
    @car_view.addSubview(@km_title_label)

    @score_label = UILabel.new
    @score_label.font = UIFont.fontWithName("Futura-CondensedExtraBold", size:40)
    @score_label.text = '0'
    @score_label.textAlignment = UITextAlignmentCenter
    @score_label.textColor = UIColor.whiteColor
    @score_label.backgroundColor = UIColor.clearColor
    @score_label.frame = [[160, 220], [150, 34]]
    @car_view.addSubview(@score_label)

    @score_title_label = UILabel.new
    @score_title_label.font = UIFont.fontWithName("Futura-CondensedExtraBold", size:16)
    @score_title_label.text = 'PUNTOS'
    @score_title_label.textAlignment = UITextAlignmentCenter
    @score_title_label.textColor = UIColor.clearColor
    @score_title_label.backgroundColor = UIColor.clearColor
    @score_title_label.frame = [[160, 250], [150, 34]]
    @car_view.addSubview(@score_title_label)

    @time_label = UILabel.new
    @time_label.font = UIFont.fontWithName("Futura-CondensedExtraBold", size:37)
    @time_label.text = '0m'
    @time_label.textAlignment = UITextAlignmentCenter
    @time_label.textColor = UIColor.clearColor
    @time_label.backgroundColor = UIColor.clearColor
    @time_label.frame = [[300, 220], [150, 34]]
    @car_view.addSubview(@time_label)

    @time_title_label = UILabel.new
    @time_title_label.font = UIFont.fontWithName("Futura-CondensedExtraBold", size:16)
    @time_title_label.text = 'MIN'
    @time_title_label.textAlignment = UITextAlignmentCenter
    @time_title_label.textColor = UIColor.clearColor
    @time_title_label.backgroundColor = UIColor.clearColor
    @time_title_label.frame = [[300, 250], [150, 34]]
    @car_view.addSubview(@time_title_label)

    @buttonMap = UIButton.buttonWithType(UIButtonTypeRoundedRect)
    @buttonMap.frame = [[10, 25],[20, 20]]
    @buttonMap.addTarget(self, action: :clickShowMap, forControlEvents: UIControlEventTouchUpInside)
    @car_view.addSubview(@buttonMap)

    @simul_acel = UIButton.buttonWithType(UIButtonTypeRoundedRect)
    @simul_acel.frame = [[10, 195],[20, 20]]    
    @simul_acel.addTarget(self, action: :clickSimulAcel, forControlEvents: UIControlEventTouchUpInside)    
    @car_view.addSubview(@simul_acel)

    @simul_loc = UIButton.buttonWithType(UIButtonTypeRoundedRect)
    @simul_loc.frame = [[10, 215],[20, 20]]
    @simul_loc.addTarget(self, action: :clickSimulLoc, forControlEvents: UIControlEventTouchUpInside)
    @car_view.addSubview(@simul_loc)

    @state_icon = UIView.alloc.initWithFrame([[380, 20], [81, 81]])
    @state_icon.backgroundColor = UIColor.clearColor
    self.view.addSubview(@state_icon)
   
  end

  def shouldAutorotateToInterfaceOrientation(orientation)
    if orientation != UIDeviceOrientationLandscapeLeft
      return false
    else
      return true
    end
  end
end