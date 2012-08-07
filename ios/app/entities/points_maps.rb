class PointsMaps

  def initialize(latitude, longitude, pointName)
    @name = pointName
    @coordinate = CLLocationCoordinate2D.new(latitude, longitude)
  end

  def title; @name; end
  def coordinate; @coordinate; end

  Data = [
    PointsMaps.new(19.301932, -99.081357, 'Xochi'),
    PointsMaps.new(19.301605, -99.080007, 'Acoxpa'),
    PointsMaps.new(19.300451, -99.079664, 'Coapa')
  ]

end
