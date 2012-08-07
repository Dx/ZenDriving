class MapViewController < UIViewController
  def init
    self
  end

  def loadView
    self.view = MKMapView.alloc.init
    view.delegate = self
  end

  def viewDidLoad
  end

  def viewWillAppear(animated)
    region = MKCoordinateRegionMake(CLLocationCoordinate2D.new(19.297874, -99.080229), MKCoordinateSpanMake(0.01, 0.02))
    self.view.setRegion(region)
    PointsMaps::Data.each { |annotation| self.view.addAnnotation(annotation) }
  end
end