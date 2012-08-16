class DriverController < UIViewController

  def viewDidLoad
    @temp_score = 0
    @total_score = 0
    @temp_distance = 0
    self.view.backgroundColor = UIColor.alloc.initWithPatternImage(UIImage.imageNamed("play.png"))

    configure_ui
    suscribe_to_events

    @engine = Engine.new
    @engine.start
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

      @movement_label.text = notification.object.distance.to_i.to_s

      @temp_score += notification.object.distance.to_i

      if @temp_distance + notification.object.distance.to_i <= 100
        @temp_distance += notification.object.distance.to_i
      else        
        @total_score += @temp_score
        @temp_distance = 0
        @temp_score = 0
      end

      @level_label.text = @temp_score.to_s
      @distance_label.text = @temp_distance.to_s
      @score_label.text = @total_score.to_s

    end

    @reload_observer = App.notification_center.observe "notificationAccelerator" do |notification|

      if @temp_score - notification.object.level < 0
        @temp_score = 0
      else
        @temp_score -= notification.object.level
      end

      @level_label.text = @temp_score.to_s
      @distance_label.text = @temp_distance.to_s
      @score_label.text = @total_score.to_s

      @accelerate_label.text = notification.object.level.to_s

      if notification.object.level > 5 && notification.object.level < 10
        self.view.backgroundColor = UIColor.alloc.initWithPatternImage(UIImage.imageNamed("warning.png"))
      elsif notification.object.level > 10
        self.view.backgroundColor = UIColor.alloc.initWithPatternImage(UIImage.imageNamed("warning2.png"))
      else
        self.view.backgroundColor = UIColor.alloc.initWithPatternImage(UIImage.imageNamed("play.png"))
      end
    end
  end

  
  def configure_ui

    @accelerate_title = UILabel.new
    @accelerate_title.font = UIFont.systemFontOfSize(20)
    @accelerate_title.text = 'Movimiento'
    @accelerate_title.textAlignment = UITextAlignmentCenter 
    @accelerate_title.textColor = UIColor.redColor
    @accelerate_title.backgroundColor = UIColor.clearColor
    @accelerate_title.frame = [[20, 20], [150, 30]]
    self.view.addSubview(@accelerate_title)

    @movement_title = UILabel.new
    @movement_title.font = UIFont.systemFontOfSize(20)
    @movement_title.text = 'Nuevos metros'
    @movement_title.textAlignment = UITextAlignmentCenter
    @movement_title.textColor = UIColor.redColor
    @movement_title.backgroundColor = UIColor.clearColor
    @movement_title.frame = [[20, 50], [150, 30]]
    self.view.addSubview(@movement_title)

    @distance_title = UILabel.new
    @distance_title.font = UIFont.systemFontOfSize(20)
    @distance_title.text = 'Medida 100m'
    @distance_title.textAlignment = UITextAlignmentCenter
    @distance_title.textColor = UIColor.redColor
    @distance_title.backgroundColor = UIColor.clearColor
    @distance_title.frame = [[20, 80], [150, 30]]
    self.view.addSubview(@distance_title)

    @level_title = UILabel.new
    @level_title.font = UIFont.systemFontOfSize(20)
    @level_title.text = 'Score 100m'
    @level_title.textAlignment = UITextAlignmentCenter
    @level_title.textColor = UIColor.redColor
    @level_title.backgroundColor = UIColor.clearColor
    @level_title.frame = [[20, 110], [150, 30]]
    self.view.addSubview(@level_title)

    @score_title = UILabel.new
    @score_title.font = UIFont.systemFontOfSize(20)
    @score_title.text = 'SCORE TOTAL'
    @score_title.textAlignment = UITextAlignmentCenter
    @score_title.textColor = UIColor.blackColor
    @score_title.backgroundColor = UIColor.clearColor
    @score_title.frame = [[20, 140], [150, 30]]
    self.view.addSubview(@score_title)

    @accelerate_label = UILabel.new
    @accelerate_label.font = UIFont.systemFontOfSize(25)
    @accelerate_label.text = 'ACE'
    @accelerate_label.textAlignment = UITextAlignmentCenter 
    @accelerate_label.textColor = UIColor.redColor
    @accelerate_label.backgroundColor = UIColor.clearColor
    @accelerate_label.frame = [[180, 20], [150, 30]]
    self.view.addSubview(@accelerate_label)

    @movement_label = UILabel.new
    @movement_label.font = UIFont.systemFontOfSize(25)
    @movement_label.text = 'MOVE'
    @movement_label.textAlignment = UITextAlignmentCenter
    @movement_label.textColor = UIColor.redColor
    @movement_label.backgroundColor = UIColor.clearColor
    @movement_label.frame = [[180, 50], [150, 30]]
    self.view.addSubview(@movement_label)

    @distance_label = UILabel.new
    @distance_label.font = UIFont.systemFontOfSize(25)
    @distance_label.text = 'DIST'
    @distance_label.textAlignment = UITextAlignmentCenter
    @distance_label.textColor = UIColor.redColor
    @distance_label.backgroundColor = UIColor.clearColor
    @distance_label.frame = [[180, 80], [150, 30]]
    self.view.addSubview(@distance_label)

    @level_label = UILabel.new
    @level_label.font = UIFont.systemFontOfSize(25)
    @level_label.text = 'LEVEL'
    @level_label.textAlignment = UITextAlignmentCenter
    @level_label.textColor = UIColor.redColor
    @level_label.backgroundColor = UIColor.clearColor
    @level_label.frame = [[180, 110], [150, 30]]
    self.view.addSubview(@level_label)

    @score_label = UILabel.new
    @score_label.font = UIFont.systemFontOfSize(25)
    @score_label.text = 'SCORE'
    @score_label.textAlignment = UITextAlignmentCenter
    @score_label.textColor = UIColor.blackColor
    @score_label.backgroundColor = UIColor.clearColor
    @score_label.frame = [[180, 140], [150, 30]]
    self.view.addSubview(@score_label)
  end
end