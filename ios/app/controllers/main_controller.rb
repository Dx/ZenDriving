class MainController < UIViewController

  def viewDidLoad    
    configureUI
  end

  def initializeVariables    
    @initial_x_value = 0
    @initial_y_value = 0
    @fill_value = 50
    @distance_value = 0
    @initialTime = Time.new
    @snapshots = Array.new(4)
    @is_started = false
  end

  def add_movement(new_snapshot)    
    if @first_movement.nil?
      @first_movement = new_snapshot      
    else
      if @middle_movement.nil?
        @middle_movement = @first_movement
      elsif !@last_movement.nil?
        @middle_movement = @last_movement
      end
    end

    @last_movement = new_snapshot
  end

  def calculate (theTimer)
    if !@last_movement.nil?

      @distance_value = haversin_distance(@last_movement.lat, @last_movement.lon,
        @first_movement.lat, @first_movement.lon)
      
      @time_value = @last_movement.time - @first_movement.time
      
      if !@middle_movement.nil? && !@last_movement.nil?
        if @fill_value < 100  
          @fill_value += haversin_distance(@middle_movement.lat, @middle_movement.lon, @last_movement.lat, @last_movement.lon).to_i
        else
          @fill_value = 100
        end
      end

      showResults

    end    
  end

  def showResults
    @fill.text = @fill_value.to_s
    @distance.text = @distance_value.to_i.to_s
    @time.text = @time_value.to_i.to_s
  end

  def initializeTimer
    @timer = NSTimer.scheduledTimerWithTimeInterval (1.0, target:self, selector:'calculate:', userInfo:nil, repeats:'YES')
  end

  

  def configureUI
    
    margin = 20
    self.title = "Zen Driving"

    @move_label = UILabel.new
    @move_label.font = UIFont.systemFontOfSize(15)
    @move_label.text = "Diff:"
    @move_label.textAlignment = UITextAlignmentCenter
    @move_label.textColor = UIColor.yellowColor
    @move_label.backgroundColor = UIColor.clearColor
    @move_label.frame = [[10, 80], [60, 20]]
    view.addSubview(@move_label)

    @move_x = UILabel.new
    @move_x.font = UIFont.systemFontOfSize(20)
    @move_x.text = "x"
    @move_x.textAlignment = UITextAlignmentCenter
    @move_x.textColor = UIColor.yellowColor
    @move_x.backgroundColor = UIColor.clearColor
    @move_x.frame = [[70, 80], [90, 20]]
    view.addSubview(@move_x)

    @move_y = UILabel.new
    @move_y.font = UIFont.systemFontOfSize(20)
    @move_y.text = "y"
    @move_y.textAlignment = UITextAlignmentCenter
    @move_y.textColor = UIColor.yellowColor
    @move_y.backgroundColor = UIColor.clearColor
    @move_y.frame = [[200, 80], [90, 20]]
    view.addSubview(@move_y)


    @time_label = UILabel.new
    @time_label.font = UIFont.systemFontOfSize(15)
    @time_label.text = 'Time elapsed in seconds'
    @time_label.textAlignment = UITextAlignmentCenter
    @time_label.textColor = UIColor.whiteColor
    @time_label.backgroundColor = UIColor.clearColor
    @time_label.frame = [[margin, 100], [view.frame.size.width - margin * 2, 20]]
    view.addSubview(@time_label)

    @time = UILabel.new
    @time.font = UIFont.systemFontOfSize(20)
    @time.text = 'Time'
    @time.textAlignment = UITextAlignmentCenter
    @time.textColor = UIColor.whiteColor
    @time.backgroundColor = UIColor.clearColor
    @time.frame = [[margin, 120], [view.frame.size.width - margin * 2, 20]]
    view.addSubview(@time)

    @distance_label = UILabel.new
    @distance_label.font = UIFont.systemFontOfSize(15)
    @distance_label.text = 'Distance in meters'
    @distance_label.textAlignment = UITextAlignmentCenter
    @distance_label.textColor = UIColor.redColor
    @distance_label.backgroundColor = UIColor.clearColor
    @distance_label.frame = [[margin, 140], [view.frame.size.width - margin * 2, 20]]
    view.addSubview(@distance_label)

    @distance = UILabel.new
    @distance.font = UIFont.systemFontOfSize(20)
    @distance.text = 'Distance'
    @distance.textAlignment = UITextAlignmentCenter
    @distance.textColor = UIColor.redColor
    @distance.backgroundColor = UIColor.clearColor
    @distance.frame = [[margin, 160], [view.frame.size.width - margin * 2, 20]]
    view.addSubview(@distance)

    @fill_label = UILabel.new
    @fill_label.font = UIFont.systemFontOfSize(15)
    @fill_label.text = 'Score'
    @fill_label.textAlignment = UITextAlignmentCenter
    @fill_label.textColor = UIColor.whiteColor
    @fill_label.backgroundColor = UIColor.clearColor
    @fill_label.frame = [[margin, 180], [view.frame.size.width - margin * 2, 20]]
    view.addSubview(@fill_label)

    @fill = UILabel.new
    @fill.font = UIFont.systemFontOfSize(20)
    @fill.text = 'Fill'
    @fill.textAlignment = UITextAlignmentCenter
    @fill.textColor = UIColor.whiteColor
    @fill.backgroundColor = UIColor.clearColor
    @fill.frame = [[margin, 200], [view.frame.size.width - margin * 2, 20]]
    view.addSubview(@fill)

    @start_button = UIButton.buttonWithType(UIButtonTypeRoundedRect)
    @start_button.setTitle("Start", forState:UIControlStateNormal)
    @start_button.frame = [[10,30], [100, 50]]
    @start_button.addTarget(self, action: :start, forControlEvents:UIControlEventTouchUpInside)
    view.addSubview(@start_button)

    @stop_button = UIButton.buttonWithType(UIButtonTypeRoundedRect)
    @stop_button.setTitle("Stop", forState:UIControlStateNormal)
    @stop_button.frame = [[150,30], [100, 50]]
    @stop_button.addTarget(self, action: :stop, forControlEvents:UIControlEventTouchUpInside)
    view.addSubview(@stop_button)

    @showmap_button = UIButton.buttonWithType(UIButtonTypeRoundedRect)
    @showmap_button.frame = [[67, 320], [180, 30]]
    @showmap_button.setTitle("Map", forState:UIControlStateNormal)
    @showmap_button.addTarget(self, action: :clicked, forControlEvents:UIControlEventTouchUpInside)
    view.addSubview(@showmap_button)
  end

  def start
    initializeVariables
    initializeAccelerometer
    initializeTimer
    @is_started = true

  end

  def stop

    if !@timer.isnil?
      @timer.invalidate
      @timer = nil
    end
    
    @is_started = false
    map_view_controller = MapViewController.alloc.initWithNibName(nil, bundle:nil)
    self.navigationController.pushViewController(map_view_controller, animated:true)

  end

  def clicked
    @mapViewController = MapViewController.alloc.init
    self.navigationController.pushViewController(@mapViewController, animated:true)
  end

end
