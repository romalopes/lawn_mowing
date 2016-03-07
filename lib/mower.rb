require "lawn_mowing/version"

class String
  def is_integer?
    self.to_i.to_s == self
  end
end

module LawnMowing
	class Mower
  	DIRECTIONS = ["S", "E", "N", "W"]
  	attr_accessor :index, :x, :y, :direction, :moves

  	def initialize(x, y, direction)
  		@x = x.to_i
  		@y = y.to_i 
  		@direction = direction
  		@index = nil
  		@initial_x = @x 
  		@initial_y = @y 
  		@initial_direction = @direction
  	end

    def moves_string
      self.moves.join("").chomp
    end

	  def print_position_direction
	  	puts "#{@x} #{@y} #{@direction}"
	  end

  end

  ##########################################
  # ManualMower
  ##########################################
  class ManualMower < Mower
  	attr_accessor :x_temp, :y_temp, :index_movement, :number_tries

  	def self.test(arg)
  		puts "\n\n\n\n ------ test #{arg}\n\n\n\n"
  	end
  	def initialize(x, y, direction, moves = "")
  		super(x, y, direction)
  		@moves = moves.nil? ? [] : moves.split("")
  		@index_movement = 0
  		@number_tries = 0
  	end

  	def verify_position_inside_lawn?(x_temp, y_temp, lawn_x, lawn_y)
  		return (x_temp >= 0 && x_temp <= lawn_x && y_temp >= 0 && y_temp <= lawn_y)
  	end

	  def current_movement
	  	self.moves[self.index_movement]
	  end

	  def do_turn(movement = nil)
  		movement ||= current_movement
  		dir = Mower::DIRECTIONS.index(@direction)
  		if movement == "L" 
  			dir = (dir == 3) ? 0 : dir + 1
  		elsif movement == "R" 
  			dir = (dir == 0) ? 3 : dir - 1
  		end
  		@direction = Mower::DIRECTIONS[dir]
  		return true
	  end

		def is_going_outside?(lawn_x, lawn_y)
	  	return (@current_movement == "M" || @current_movement.nil?) && (@x == 0 && @direction == "S" || @x == lawn_x && @direction == "N" || @y == 0 && @direction == "W" || @y == lawn_y && @direction == "E")
	  end


		def do_move(lawn_mowers_positions = [], direction = nil)
  		direction ||= @direction
  		
  		x_temp = @x 
  		y_temp = @y
	    if direction == "N" 
	    	y_temp +=  1	
	    elsif direction == "E"
	    	x_temp += 1	
	    elsif direction == "S"
	    	y_temp -= 1	
	    elsif direction == "W"
	    	x_temp -= 1
	    end

	    fail = false
	    lawn_mowers_positions.each_with_index do |position, ind|
	    	if ind == 0 
	    		unless verify_position_inside_lawn?(x_temp, y_temp, position[0], position[1])
	    			fail = true
	    		end
	    	else
		    	if (@index != ind - 1) && (x_temp == position[0] && y_temp == position[1])
		    		fail = true
		    	end
		    end
	    end

			if fail
		  	self.number_tries += 1
		  else
		    @x = x_temp
		    @y = y_temp
		    @index_movement += 1
		  	self.number_tries = 0
		  end
	    return fail
		end

	  def do_action(lawn_mowers_positions = [])
  		if current_movement == "M"
  			return self.do_move(lawn_mowers_positions)
  		else 
  			result = self.do_turn
  			self.index_movement += 1
  			return result
  		end
	  end

  	def set_moves(moves)
  		@moves = moves.nil? ? [] : moves.split("")
  	end

  	def can_move?
	  	return self.number_tries < 10 && self.index_movement < @moves.size
	  end

	  def print_values
	  	puts "index:#{@index} ->x:#{@x}, y:#{@y}, direction:#{@direction}, moves:#{@moves}, number_tries:#{@number_tries}, index_movement:#{@index_movement}"
	  end

	  def print_output
	  	print_position_direction
	  end

	  def print_input
	  	puts "#{@initial_x} #{@initial_y} #{@initial_direction}"
	  	puts "#{@moves.join("").chomp}"
	  end

	  def print_current_output
	  	print_position_direction
	  	if !@index_movement.nil? && @index_movement < @moves.size && @number_tries < 10
	  		string = ""
	  		(0..@index_movement-1).each do |space|
	  			string << "_"
	  		end
	  		puts "#{string}\t@index_movement:#{@index_movement} number_tries:#{number_tries}"
	  	end 
	  	puts "#{@moves.join("").chomp}"
	  end


  end

  ##########################################
  # AutomaticMower
  ##########################################
  class AutomaticMower < Mower

  	attr_accessor :initial_x

  	def initialize(x)
  		super(x, 0, "N")
  		@initial_x = x 
  		@moves = []
  		@index = 0
  	end

  	def add_move(move)
  		@moves << move
  	end

  	def can_move?(lawn_mowers_positions = [])
  		mowners_count = lawn_mowers_positions.count - 1
  		return false if mowners_count <= 0

	    lawn_x = lawn_mowers_positions[0][0]
	    lawn_y = lawn_mowers_positions[0][1]

			return true if @y > 0 && @y < lawn_y

	    x_position = 0
	    if mowners_count == 1
	    	result = ( (@y == 0 || @y == lawn_y) && @x < lawn_x) || @x == lawn_x  && (@y > 0 && @direction == 'S' || @y < lawn_y && @direction == 'N') 
	    	return result
	    elsif mowners_count > 1
	    	x_position = (mowners_count > 1) ? (lawn_x + 1) / mowners_count : 1
	    	if @index == mowners_count - 1
	    		return @x < lawn_x || @x == lawn_x && (@y == 0 && @direction == 'N' || @y == lawn_y && @direction == 'S')
	    	elsif (@x < (x_position * (@index + 1) - 1))
	    		return true
	    	else
	    		return (@y > 0 && @y < lawn_y) || @y == 0 && @direction == 'N' || @y == lawn_y && @direction == 'S'
	    	end
	    	return result
	    end
	    return false

  		# puts "\nlawn_mowers_positions:#{lawn_mowers_positions}  lawn_mowers_positions.count:#{lawn_mowers_positions.count} x_position:#{x_position} = (#{lawn_x} + 1) / #{mowners_count }   x_position * (@index + 1)=#{x_position * (@index + 1)} "

  		# puts "@y > 0 && @y < lawn_y || @y == 0 && @direction == 'N' || @y == lawn_y && @direction == 'S' || (@y == 0 && @direction == 'S' || @y == lawn_y && @direction == 'N') && ( @x < (x_position * (@index + 1)) || @x == lawn_x - 1)"
	  	# puts "#{@y > 0} && #{@y < lawn_y} || #{@y == 0} && #{@direction == 'N'} || #{@y == lawn_y} && #{@direction == 'S'} || (#{@y == 0} && #{@direction == 'S'} || #{@y == lawn_y} && #{@direction == 'N'}) &&  (#{@x < (x_position * (@index + 1))} || #{@x == lawn_x - 1})"
	  
	  	# result = @y > 0 && @y < lawn_y || @y == 0 && @direction == 'N' || @y == lawn_y && @direction == 'S' || (@y == 0 && @direction == 'S' || @y == lawn_y && @direction == 'N') && ( @x < (x_position * (@index + 1) - 1) )
	  	# puts result
	  	# print_values
	  	# return result
	  end

		def do_move(lawn_mowers_positions = [], direction = nil)

			return false unless can_move?(lawn_mowers_positions)
  		direction ||= @direction
  		
  		x_temp = @x 
  		y_temp = @y
	    if direction == "N" 
	    	y_temp +=  1	
	    elsif direction == "E"
	    	x_temp += 1	
	    elsif direction == "S"
	    	y_temp -= 1	
	    elsif direction == "W"
	    	x_temp -= 1
	    end

	    mowners_count = lawn_mowers_positions.count - 1
	    return false if mowners_count <= 0

	    lawn_x = lawn_mowers_positions[0][0]
	    lawn_y = lawn_mowers_positions[0][1]

			x_position = (lawn_x + 1) / mowners_count 
	    if (y_temp < 0 || y_temp > lawn_y)
	    	if @x < (x_position * (@index + 1)) && @x <= lawn_x
	    		if y_temp < 0
	    			@direction = "N"
	    			add_move("L")
	    			@x += 1
	    			add_move("M")
	    			add_move("L")
	    		else
	    			@direction = "S"
						add_move("R")
						@x += 1
	    			add_move("M")
	    			add_move("R")
	    		end
	    	else
	    		return false
	    	end
	    else
	    	@x = x_temp
		    @y = y_temp
		    add_move("M")
	    end
	    return true
	  end

	  def do_action(lawn_mowers_positions = [])
  		return self.do_move(lawn_mowers_positions)
	  end

	 	def print_values
	  	puts "index:#{@index} ->initial_x:#{@initial_x}  x:#{@x}, y:#{@y}, direction:#{@direction}, moves:#{@moves}"
	  end

		def print_initial_position_direction
	  	puts "#{@initial_x} 0 N"
		end
	  def print_output
	  	print_initial_position_direction
	  	puts "#{@moves.join("").chomp}"
	  end
	end
end
