class AppDelegate
  def application(application, didFinishLaunchingWithOptions:launchOptions)
    @window = UIWindow.alloc.initWithFrame(UIScreen.mainScreen.bounds)
    
    first_controller = DriverController.alloc.initWithNibName(nil, bundle:nil)
    # nav_controller = UINavigationController.alloc.initWithRootViewController(first_controller)

    # driver_controller = DriverController.alloc.initWithNibName(nil, bundle:nil)
    # driver_controller.title = "Drive"

    # tab_controller = UITabBarController.alloc.initWithNibName(nil, bundle:nil)
    # tab_controller.viewControllers = [nav_controller, driver_controller]

    @window.rootViewController = first_controller

    @window.rootViewController.wantsFullScreenLayout = true
    @window.makeKeyAndVisible
    true
  end
end
