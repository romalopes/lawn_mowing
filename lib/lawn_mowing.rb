require "lawn_mowing/version"
require 'mower'

class String
  def is_integer?
    self.to_i.to_s == self
  end
end

module LawnMowing
  
  ##########################################
  # MowingSystem
  ##########################################
  class MowingSystem
  	attr_accessor :lawn_x, :lawn_y, :mowers

  	def initialize(lawn_x = 0, lawn_y = 0)
  		@lawn_x, @lawn_y = lawn_x, lawn_y
  		@mowers = []
  	end

  	def self.read_file(file_name = nil)
  		string_list = []
	    if file_name.nil?
	      file_name = LawnMowing::ManualMowingSystem::FILE_NAME
	    end
	    unless File.exist?(file_name)
	    	file_name = Dir.getwd + "/" + file_name
	    end
	    if File.exist?(file_name)
	    	puts "\n\n#{file_name}"
	      # sheep_dog_bot = SheepdogBot.new(file_name)
	      file = File.open(file_name)
	      file.each {|line|
	      	string_list << line.chomp unless line.chomp.empty?
	      }
	    else
	      error = "File #{file_name} doesn't exist."
	      return error
	    end
	    return string_list
	  end


	  def self.init_run_system(file_or_array)
	  	if !file_or_array.nil? 
	  		if file_or_array.class == Array
	  			array_lines = file_or_array
	  		elsif file_or_array.class == String
	  			array_lines = read_file(file_or_array)
	  		end

	  		if array_lines.class == Array
	  			mowing_system = init(array_lines)
	  			unless 	mowing_system.class == String
	  				mowing_system.run_system
	  				return mowing_system
	  			else
	  				puts "#{mowing_system}"
	  				return mowing_system
	  			end
	  		else 
	  			puts "#{array_lines} -> #{file_or_array}"
	  			return "#{array_lines}"
	  		end
	  	end
	  end

  	def self.init(array_lines)
  		if array_lines.size > 1 && array_lines.size % 2 == 1
  			return ManualMowingSystem.init(array_lines)
  		elsif array_lines.size == 1
  			return AutomaticMowingSystem.init(array_lines)
  		else
  			return "Not valid sequence."
  		end
  	end

  	def set_lawn_dimensions(x, y)
  		@lawn_x, @lawn_y = x, y
  		@mowers = []
  	end

  	def add_mower(mower)
  		if mower.x >= 0 && mower.x <= @lawn_x && mower.y >= 0 && mower.y <= @lawn_y
	  		mower.index = @mowers.size
	  		@mowers << mower
	  	end
  	end


  	def lawn_mowers_positions
  		positions = []
  		positions << [@lawn_x, @lawn_y]
  		@mowers.each do |mower| 
  			positions << [mower.x, mower.y]
  		end
  		return positions
  	end

  	def run_system
  		while has_possible_moves
  			@mowers.each do |mower|
					mower.do_action(self.lawn_mowers_positions)
				end
  		end
  		puts "\n\nInput"
  		print_input
  		puts "\nOutput"
  		print_output
  	end

  	def print_values
  		puts "lawn_x: #{@lawn_x} lawn_y: #{@lawn_y}"
			@mowers.each do |mower|
				mower.print_output
			end
  	end 
  end


  ##########################################
  # ManualMowingSystem
  ##########################################
  class ManualMowingSystem < MowingSystem
  	ManualMowingSystem::FILE_NAME = 'manual_mowing.txt'

  	def self.is_valid?(array_lines)
  		return false if array_lines.size % 2 == 0
  		array_lines.each_with_index do |line, index|
				split_line = line.split(' ')
				if index == 0
					return false if split_line.size != 2
					return false unless split_line[0].is_integer? && split_line[1].is_integer?
				elsif index % 2 == 1  # 1, 3, 5   ex: 1 2 N, 3 3 E
					return false if split_line.size != 3
					return false unless split_line[0].is_integer? && split_line[1].is_integer?
					return false unless /^(N|S|E|W)$/.match(split_line[2])
				else # 2, 4, 5, 6, LMLMLMLMM, MMRMMRMRRM
					return false unless /^[LRM]*$/.match(line)
				end
			end
			true
  	end

  	def self.init(array_lines)
			return "Not valid sequence." unless is_valid?(array_lines)
			manual_mowing_system = ManualMowingSystem.new			
			mower = nil
			array_lines.each_with_index do |line, index|
				split_line = line.split(' ')
				if index == 0
					manual_mowing_system.set_lawn_dimensions(split_line[0].to_i, split_line[1].to_i)
				elsif index % 2 == 1  # 1, 3, 5   ex: 1 2 N, 3 3 E
					mower = ManualMower.new(split_line[0], split_line[1], split_line[2])
					if !manual_mowing_system.add_mower(mower)
						puts "Mower with dimensions (#{split_line[0]}, #{split_line[1]}) could not fit inside the lawn."
					end
				else # 2, 4, 5, 6, LMLMLMLMM, MMRMMRMRRM
					mower.set_moves(split_line[0]) unless mower.nil?
					mower = nil
				end
			end
			return manual_mowing_system
  	end

  	#if any mower can move
  	def has_possible_moves
  		@mowers.each do |mower|
  			return true if mower.can_move? && !mower.is_going_outside?(lawn_x, lawn_y)
	  	end
  		return false
  	end

  	def print_input 
  		puts "#{@lawn_x} #{@lawn_y}"
  		@mowers.each do |mower|
  			mower.print_input
  		end
  	end

  	def print_output
  		@mowers.each do |mower|
				mower.print_output
			end
  	end
  end

  ##########################################
  # AutomaticMowingSystem
  ##########################################
  class AutomaticMowingSystem < MowingSystem
  	AutomaticMowingSystem::FILE_NAME = 'automatic_mowing.txt'

  	def self.is_valid?(array_lines)
  		return false unless array_lines.size == 1
			split_line = array_lines[0].split(' ')
			return false if split_line.size != 3
			return false unless split_line[0].is_integer? && split_line[1].is_integer? && split_line[2].is_integer?
			true
  	end

  	def self.init(array_lines)
			return "Not valid sequence." unless is_valid?(array_lines)
			line = array_lines[0]
			split_line = line.split(' ')
			automatic_mowing_system = AutomaticMowingSystem.new(split_line[0].to_i, split_line[1].to_i)
			# automatic_mowing_system.set_lawn_dimensions(split_line[0].to_i, split_line[1].to_i)
			mower = nil
			x_position =  (automatic_mowing_system.lawn_x + 1) / split_line[2].to_i
			(0..split_line[2].to_i-1).each do |index|
				automatic_mowing_system.add_mower(AutomaticMower.new(x_position * index) )
			end
			return automatic_mowing_system
  	end

  	#if any mower can move
  	def has_possible_moves
  		@mowers.each do |mower|
  			return true if mower.can_move?(lawn_mowers_positions)
	  	end
  		return false
  	end

  	def print_input 
  		puts "#{@lawn_x} #{lawn_y} #{@mowers.count}"
  	end

  	def print_output
  		@mowers.each do |mower|
				mower.print_output
			end
  	end
  end
end
