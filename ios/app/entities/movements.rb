class Movements
	def first_movement; @first_movement; end
	def middle_movement; @middle_movement; end
	def last_movement; @last_movement; end

	def initialize(new_snapshot)
    self.add_movement(new_snapshot)
	end

	def add_movement(new_snapshot)
		
		if @first_movement.nil?
			if @middle_movement == nil
				@middle_movement = @first_movement 
			else
				@middle_movement = @last_movement
			end

			@last_movement = @new_snapshot
		else
			@first_movement = new_snapshot			
			
		end
	end
end