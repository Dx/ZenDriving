class MovementNotification
  def distance; @distance; end
  def coordinate; @coordinate; end

  def initialize(distance, coordinate)
  	@distance = distance
  	@coordinate = coordinate
  end
end