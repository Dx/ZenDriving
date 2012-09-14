describe "Application 'Zendrive'" do
  before do
    @driver = DriverController.new
  end

  it "starts in zero" do

    @driver.tempScore.should.equal 0
    @driver.totalScore.should.equal 0
    @driver.tempDistance.should.equal 0
    @driver.bestScore.should.equal 0
  end
end