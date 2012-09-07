class MapViewController < UIViewController
  BACKGROUND = "bgGray.png"
  NEW_RECORD = "labelNewRecore.png"
  attr_writer :points
  attr_writer :pts
  attr_writer :km
  attr_writer :min

  def loadView
    self.view = UIView.alloc.init
    self.view.backgroundColor = getImage(BACKGROUND)

    @mapView = MKMapView.alloc.initWithFrame(CGRectMake(300, 0, 220, 300)) 
    #self.view.delegate = self
    self.view.addSubview(@mapView)
    tapRec = UITapGestureRecognizer.alloc.initWithTarget(self, action: :didTapMap)
    @mapView.addGestureRecognizer(tapRec)

    infoLayer = @mapView.layer
    infoLayer.setBorderWidth(10)
    infoLayer.setBorderColor(UIColor.blackColor.CGColor)

    @trackView = UIView.alloc.initWithFrame(CGRectMake(30, 30, 280, 35))
    @trackView.backgroundColor = UIColor.blackColor

    @trackLabel = UILabel.alloc.init
    @trackLabel.text = "Home to Office"
    @trackLabel.textAlignment =  UITextAlignmentCenter
    @trackLabel.frame = [[0, 0], [170, 35]]
    @trackLabel.setTextColor(UIColor.whiteColor)
    @trackLabel.setBackgroundColor(UIColor.clearColor)
    @trackLabel.setFont(UIFont.fontWithName("Trebuchet MS", size: 20.0))
    @trackView.addSubview(@trackLabel)
    self.view.addSubview(@trackView)

    @pointsView = UIView.alloc.initWithFrame(CGRectMake(40, 90, 230, 61))
    @pointsView.backgroundColor = getImage(NEW_RECORD)
    @pointsLabel = UILabel.alloc.init
    @pointsLabel.text = "     " + @pts + " puntos"
    @pointsLabel.textAlignment =  UITextAlignmentCenter
    @pointsLabel.frame = [[0, 0], [230, 61]]
    @pointsLabel.setTextColor(UIColor.blackColor)
    @pointsLabel.setBackgroundColor(UIColor.clearColor)
    @pointsLabel.setFont(UIFont.fontWithName("Trebuchet MS", size: 20.0))
    @pointsView.addSubview(@pointsLabel)
    self.view.addSubview(@pointsView)

    @kmLabel = UILabel.alloc.init
    @kmLabel.text = @km + " km"
    @kmLabel.textAlignment =  UITextAlignmentCenter
    @kmLabel.frame = [[57, 130], [230, 61]]
    @kmLabel.setTextColor(UIColor.blackColor)
    @kmLabel.setBackgroundColor(UIColor.clearColor)
    @kmLabel.setFont(UIFont.fontWithName("Trebuchet MS", size: 20.0))
    self.view.addSubview(@kmLabel)

    @minLabel = UILabel.alloc.init
    @minLabel.text = @min + " min"
    @minLabel.textAlignment =  UITextAlignmentCenter
    @minLabel.frame = [[57, 170], [230, 61]]
    @minLabel.setTextColor(UIColor.blackColor)
    @minLabel.setBackgroundColor(UIColor.clearColor)
    @minLabel.setFont(UIFont.fontWithName("Trebuchet MS", size: 20.0))
    self.view.addSubview(@minLabel)

    @buttonGame = UIButton.buttonWithType(UIButtonTypeCustom)
    @buttonGame.setBackgroundImage(UIImage.imageNamed("btnNewGame.png"), forState:UIControlStateNormal)
    @buttonGame.setBackgroundImage(UIImage.imageNamed("btnNewGame.png"), forState:UIControlStateHighlighted)
    @buttonGame.frame = [[95, 230],[135, 50]]

    @buttonGame.addTarget(self, action: :clickGame, forControlEvents: UIControlEventTouchUpInside)

    self.view.addSubview(@buttonGame)
  end

  def didTapMap
    @mapPointsView = NVMapViewController.alloc.initWithPoints(@points)
    #@returnView = UIView.alloc.initWithFrame(CGRectMake(30, 30, 280, 35))
    #@returnView.backgroundColor = UIColor.blackColor
    #@mapPointsView.addSubview(@returnView)
    self.presentModalViewController(@mapPointsView, animated:true)
  end

  def clickGame
    self.dismissModalViewControllerAnimated(true)
  end

  def viewDidLoad
    UIApplication.sharedApplication.setStatusBarOrientation(UIInterfaceOrientationLandscapeRight)
  end

  def viewWillAppear(animated)
    region = MKCoordinateRegionMake(CLLocationCoordinate2D.new(19.297874, -99.080229), MKCoordinateSpanMake(0.01, 0.02))
    @mapView.setRegion(region)
    #PointsMaps::Data.each { |annotation| self.view.addAnnotation(annotation) }
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