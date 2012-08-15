class DriverController < UIViewController

  def viewDidLoad
    self.view.backgroundColor = UIColor.alloc.initWithPatternImage(UIImage.imageNamed("play.png"))

    configure_ui
    suscribe_to_events

    @engine = Engine.new
    @engine.start
  end

  def suscribe_to_events
    @foreground_observer = App.notification_center.observe "notificationLocator" do |notification|
      @movement_label.text = notification.object.distance.to_s      
    end

    @reload_observer = App.notification_center.observe "notificationAccelerator" do |notification|
      @accelerate_label.text = notification.object.level.to_s
      if notification.object.level > 10 && notification.object.level < 20
        self.view.backgroundColor = UIColor.alloc.initWithPatternImage(UIImage.imageNamed("warning.png"))
      elsif notification.object.level > 20
        self.view.backgroundColor = UIColor.alloc.initWithPatternImage(UIImage.imageNamed("alert.png"))
      else
        self.view.backgroundColor = UIColor.alloc.initWithPatternImage(UIImage.imageNamed("play.png"))
      end
    end
  end

  def configure_ui
    @accelerate_label = UILabel.new
    @accelerate_label.font = UIFont.systemFontOfSize(25)
    @accelerate_label.text = 'ACE'
    @accelerate_label.textAlignment = UITextAlignmentCenter 
    @accelerate_label.textColor = UIColor.redColor
    @accelerate_label.backgroundColor = UIColor.clearColor
    @accelerate_label.frame = [[20, 20], [150, 130]]
    self.view.addSubview(@accelerate_label)

    @movement_label = UILabel.new
    @movement_label.font = UIFont.systemFontOfSize(25)
    @movement_label.text = 'MOVE'
    @movement_label.textAlignment = UITextAlignmentCenter
    @movement_label.textColor = UIColor.redColor
    @movement_label.backgroundColor = UIColor.clearColor
    @movement_label.frame = [[20, 50], [150, 180]]
    self.view.addSubview(@movement_label)
  end


  
end