class DriverController < UIViewController

  def viewDidLoad
    @temp_score = 0
    @total_score = 0
    @temp_distance = 0

    self.view.backgroundColor = UIColor.blackColor

    @level_view = UIView.alloc.initWithFrame [[0, 215], [400, 400]]
    @level_view.backgroundColor = UIColor.yellowColor

    self.view.addSubview(@level_view)

    @score_view = UIView.alloc.initWithFrame [[0, 215], [400, 400]]
    @score_view.backgroundColor = UIColor.blueColor

    self.view.addSubview(@score_view)

    @car_view = UIView.alloc.initWithFrame [[0, 0], [480, 320]]
    @car_view.backgroundColor = UIColor.alloc.initWithPatternImage(UIImage.imageNamed("play1.png"))

    self.view.addSubview(@car_view)



    configure_ui
    suscribe_to_events

    view

    @engine = Engine.new
    @engine.start
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

  def touchesEnded(touches, withEvent:event)
    if @engine.status == 1
      @engine.pause
      self.view.backgroundColor = UIColor.alloc.initWithPatternImage(UIImage.imageNamed("pause.png"))
    elsif @engine.status == 0
      @engine.start
      self.view.backgroundColor = UIColor.alloc.initWithPatternImage(UIImage.imageNamed("play.png"))
    end
  end

  def shouldAutorotateToInterfaceOrientation(orientation)
    if orientation == UIDeviceOrientationPortraitUpsideDown
      return false
    end
    true
  end

  def suscribe_to_events
    @foreground_observer = App.notification_center.observe "notificationLocator" do |notification|

      @temp_score += notification.object.distance.to_i

      if @temp_distance + notification.object.distance.to_i <= 100
        @temp_distance += notification.object.distance.to_i
      else        
        @total_score += (@temp_score > 100) ? 100 : @temp_score
        animate_to_next_point @level_view, 100
        @temp_distance = 0
        @temp_score = 0
      end

      @level_label.text = @temp_score.to_s
      @score_label.text = @total_score.to_s
      animate_to_next_point @level_view, @temp_distance
      animate_to_next_point @score_view, @temp_score

    end

    @reload_observer = App.notification_center.observe "notificationAccelerator" do |notification|

      if @temp_score - notification.object.level < 0
        @temp_score = 0
      else
        @temp_score -= notification.object.level
      end

      @level_label.text = @temp_score.to_s
      @score_label.text = @total_score.to_s

      animate_to_next_point @level_view, @temp_distance
      animate_to_next_point @score_view, @temp_score

      @accelerate_label.text = notification.object.level.to_s

      if notification.object.level > 5 && notification.object.level <= 10
        self.view.backgroundColor = UIColor.alloc.initWithPatternImage(UIImage.imageNamed("warning.png"))
      elsif notification.object.level > 10
        self.view.backgroundColor = UIColor.alloc.initWithPatternImage(UIImage.imageNamed("warning2.png"))
      else
        self.view.backgroundColor = UIColor.alloc.initWithPatternImage(UIImage.imageNamed("play1.png"))
      end
    end
  end

  
  def configure_ui

    @accelerate_label = UILabel.new
    @accelerate_label.font = UIFont.systemFontOfSize(15)
    @accelerate_label.text = 'Acel'
    @accelerate_label.textAlignment = UITextAlignmentCenter 
    @accelerate_label.textColor = UIColor.whiteColor
    @accelerate_label.backgroundColor = UIColor.clearColor
    @accelerate_label.frame = [[20, 20], [150, 30]]
    self.view.addSubview(@accelerate_label)

    @level_label = UILabel.new
    @level_label.font = UIFont.systemFontOfSize(35)
    @level_label.text = '0'
    @level_label.textAlignment = UITextAlignmentCenter
    @level_label.textColor = UIColor.whiteColor
    @level_label.backgroundColor = UIColor.clearColor
    @level_label.frame = [[160, 150], [150, 30]]
    self.view.addSubview(@level_label)

    @score_label = UILabel.new
    @score_label.font = UIFont.systemFontOfSize(35)
    @score_label.text = '0'
    @score_label.textAlignment = UITextAlignmentCenter
    @score_label.textColor = UIColor.blueColor
    @score_label.backgroundColor = UIColor.clearColor
    @score_label.frame = [[160, 250], [150, 30]]
    self.view.addSubview(@score_label)
  end
end