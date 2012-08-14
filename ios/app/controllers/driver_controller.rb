class DriverController < UIViewController

  def viewDidLoad
    self.view.backgroundColor = UIColor.alloc.initWithPatternImage(UIImage.imageNamed("play.png"))

    NSNotificationCenter.defaultCenter.addObserver(self, selector:"notificateLocator", name:"notificateLocator", object:locatorNotif)

    NSNotificationCenter.defaultCenter.addObserver(self, selector:"notificateAccelerator", name:"notificateAccelerator", object:acceleratorNotif)
  end

  def notificateLocator(locatorNotif)
    @movement_label = locatorNotif.distance.to_s
  end

  def notificateAccelerator(acceleratorNotif)
    @accelerate_label = acceleratorNotif.to_s
  end

  def configureUI
    @accelerate_label = UILabel.new
    @accelerate_label.font = UIFont.systemFontOfSize(15)
    @accelerate_label.text = 'ACE'
    @accelerate_label.textAlignment = UITextAlignmentCenter
    @accelerate_label.textColor = UIColor.whiteColor
    @accelerate_label.backgroundColor = UIColor.clearColor
    @accelerate_label.frame = [[margin, 100], [view.frame.size.width - margin * 2, 20]]
    self.view.addSubview(@accelerate_label)

    @movement_label = UILabel.new
    @movement_label.font = UIFont.systemFontOfSize(15)
    @movement_label.text = 'MOVE'
    @movement_label.textAlignment = UITextAlignmentCenter
    @movement_label.textColor = UIColor.whiteColor
    @movement_label.backgroundColor = UIColor.clearColor
    @movement_label.frame = [[margin, 100], [view.frame.size.width - margin * 2, 20]]
    self.view.addSubview(@movement_label)
  end


  
end