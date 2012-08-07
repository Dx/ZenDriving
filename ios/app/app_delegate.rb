class AppDelegate
  def application(application, didFinishLaunchingWithOptions:launchOptions)
    @window = UIWindow.alloc.initWithFrame(UIScreen.mainScreen.bounds)
    
    first_controller = MainController.alloc.initWithNibName(nil, bundle:nil)
    nav_controller = UINavigationController.alloc.initWithRootViewController(first_controller)


    historic_controller = UIViewController.alloc.initWithNibName(nil, bundle:nil)
    historic_controller.title = "History"

    tab_controller = UITabBarController.alloc.initWithNibName(nil, bundle:nil)
    tab_controller.viewControllers = [nav_controller, historic_controller]

    @window.rootViewController = tab_controller

    @window.rootViewController.wantsFullScreenLayout = true
    @window.makeKeyAndVisible
    true
  end
end
