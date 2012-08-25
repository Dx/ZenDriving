class RootViewController < UIViewController
  def loadView
    self.view = UIView.alloc.init
  end

  def viewDidLoad
    UIApplication.sharedApplication.setStatusBarOrientation(UIInterfaceOrientationLandscapeLeft)

    self.view.backgroundColor = UIColor.alloc.initWithPatternImage(UIImage.imageNamed("bgGray.png"))

    @buttonGame = UIButton.buttonWithType(UIButtonTypeRoundedRect)
    @buttonGame.frame = [[120, 170],[81, 81]]
    @buttonGame.setBackgroundImage(UIImage.imageNamed("btnPlayActive.png"), forState:UIControlStateNormal)

    @buttonGame.addTarget(self, action: :clickGame, forControlEvents: UIControlEventTouchUpInside)

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
end