class RootViewController < UIViewController
  def loadView
    self.view = UIView.alloc.init
  end

  def viewDidLoad
    UIApplication.sharedApplication.setStatusBarOrientation(UIInterfaceOrientationPortrait)

    self.view.backgroundColor = UIColor.lightGrayColor

    @buttonGame = UIButton.buttonWithType(UIButtonTypeRoundedRect)
    @buttonGame.frame = [[120, 170],[50, 50]]

    @buttonGame.addTarget(self, action: :clickGame, forControlEvents: UIControlEventTouchUpInside)

    self.view.addSubview(@buttonGame)
  end

  def clickGame
    self.presentModalViewController(DriverController.alloc.init, animated:true)
  end

  def shouldAutorotateToInterfaceOrientation(orientation)
    if orientation != UIDeviceOrientationPortrait
      return false
    else
      return true
    end
  end
end