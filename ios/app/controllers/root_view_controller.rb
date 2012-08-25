class RootViewController < UIViewController
  BACKGROUND = "bgGray.png"
  LOGO = "logo.png"

  def loadView
    self.view = UIView.alloc.init
  end

  def viewDidLoad
    UIApplication.sharedApplication.setStatusBarOrientation(UIInterfaceOrientationLandscapeRight)
    self.view.backgroundColor = getImage(BACKGROUND)

    @logo = UIView.alloc.init
    @logo.frame = [[25, 95], [120, 116]]
    @logo.backgroundColor = getImage(LOGO)

    @buttonGame = UIButton.buttonWithType(UIButtonTypeCustom)
    @buttonGame.setBackgroundImage(UIImage.imageNamed("btnPlayInactive.png"), forState:UIControlStateNormal)
    @buttonGame.setBackgroundImage(UIImage.imageNamed("btnPlayActive.png"), forState:UIControlStateHighlighted)
    @buttonGame.frame = [[320, 100],[100, 100]]

    @buttonGame.addTarget(self, action: :clickGame, forControlEvents: UIControlEventTouchUpInside)

    self.view.addSubview(@logo)
    self.view.addSubview(@buttonGame)
  end

  def clickGame
    self.presentModalViewController(DriverController.alloc.init, animated:true)
  end

  def shouldAutorotateToInterfaceOrientation(orientation)
    if orientation != UIDeviceOrientationLandscapeLeft
      return false
    else
      return true
    end
  end

  def getImage(image)
    UIColor.alloc.initWithPatternImage(UIImage.imageNamed(image))      
  end
end