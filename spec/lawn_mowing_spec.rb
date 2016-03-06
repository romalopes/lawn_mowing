require 'spec_helper'
require 'lawn_mowing'


describe "Roma" do
  pending "write it"
end

describe LawnMowing::ManualMower do 
	describe "creating and dealing with mower" do 
		it "initialize" do
			mower = LawnMowing::ManualMower.new(1, 2, "N", "LMLMLM")
			expect(mower.index).to eql(nil)
			expect(mower.x).to eql(1)
			expect(mower.y).to eql(2)
			expect(mower.direction).to eql("N")
			expect(mower.moves).to eql(["L", "M", "L", "M", "L", "M"])
			expect(mower.number_tries).to eql(0)
			expect(mower.index_movement).to eql(0)
		end

		it "set moves" do 
			mower = LawnMowing::ManualMower.new(1, 2, "N")
			expect(mower.moves).to eql([])
			mower.set_moves("LMLMLM")
			expect(mower.moves).to eql(["L", "M", "L", "M", "L", "M"])
		end

		it "doing a movements" do
			mower = LawnMowing::ManualMower.new(1, 2, "N")
			mower.do_move
			expect(mower.x).to eql(1)
			expect(mower.y).to eql(3)
			expect(mower.direction).to eql("N")

			mower = LawnMowing::ManualMower.new(1, 2, "S")
			mower.do_move
			expect(mower.x).to eql(1)
			expect(mower.y).to eql(1)
			expect(mower.direction).to eql("S")

			mower = LawnMowing::ManualMower.new(1, 2, "W")
			mower.do_move
			expect(mower.x).to eql(0)
			expect(mower.y).to eql(2)
			expect(mower.direction).to eql("W")

			mower = LawnMowing::ManualMower.new(1, 2, "E")
			mower.do_move
			expect(mower.x).to eql(2)
			expect(mower.y).to eql(2)
			expect(mower.direction).to eql("E")
		end

		it "doing a turns" do
			mower = LawnMowing::ManualMower.new(1, 2, "N")
			mower.do_turn("L")
			expect(mower.x).to eql(1)
			expect(mower.y).to eql(2)
			expect(mower.direction).to eql("W")

			mower.do_turn("L")
			expect(mower.direction).to eql("S")

			mower.do_turn("L")
			expect(mower.direction).to eql("E")

			mower.do_turn("L")
			expect(mower.direction).to eql("N")

			mower.do_turn("R")
			expect(mower.direction).to eql("E")

			mower.do_turn("R")
			expect(mower.direction).to eql("S")

			mower.do_turn("R")
			expect(mower.direction).to eql("W")

			mower.do_turn("R")
			expect(mower.direction).to eql("N")
		end

		it "can move" do 
			mower = LawnMowing::ManualMower.new(1, 2, "N", "MRRRRRM")
			expect(mower.can_move?).to eql(true)

			mower.number_tries = 10
			expect(mower.can_move?).to eql(false)

			mower.number_tries = 0
			mower.index_movement = "MRRRRRM".size
			expect(mower.can_move?).to eql(false)

		end

		it "doing actions" do

			mower = LawnMowing::ManualMower.new(1, 2, "N", "MMML")
			mower.do_action([[5,5], [4,4] ])
			expect(mower.x).to eql(1)
			expect(mower.y).to eql(3)
			expect(mower.index_movement).to eql(1)
		end
	end

	describe "init and running system" do 
		it "when passes a wrong file" do
			result = LawnMowing::MowingSystem.init_run_system("NO FILE")
			expect(result.include?("NO FILE doesn")).to eql(true)
		end

		it "when passes a file with wrong format" do
			result = LawnMowing::MowingSystem.init_run_system("file_wrong_format.txt")
			expect(result.include?("Not valid sequence.")).to eql(true)
		end
		
		it "when passes a manual file" do 
			mowing_system = LawnMowing::MowingSystem.init_run_system("manual_mowing.txt")
			expect(mowing_system.lawn_x).to eql(5)
			expect(mowing_system.lawn_y).to eql(5)

			mower = mowing_system.mowers[0] 
			expect(mower.x).to eql(1)
			expect(mower.y).to eql(3)
			expect(mower.direction).to eql("N")
			expect(mower.moves).to eql(["L", "M", "L", "M", "L", "M", "L", "M", "M"])

			mower = mowing_system.mowers[1] 
			expect(mower.x).to eql(5)
			expect(mower.y).to eql(1)
			expect(mower.direction).to eql("E")
			expect(mower.moves).to eql(["M", "M", "R", "M", "M", "R", "M", "R", "R", "M"])
		end

		it "when passes an automatic file" do 
			mowing_system = LawnMowing::MowingSystem.init_run_system("automatic_mowing.txt")
			expect(mowing_system.lawn_x).to eql(5)
			expect(mowing_system.lawn_y).to eql(5)

			mower = mowing_system.mowers[0] 
			expect(mower.x).to eql(1)
			expect(mower.y).to eql(0)
			expect(mower.direction).to eql("S")
			expect(mower.moves).to eql(["M", "M", "M", "M", "M", "R", "M", "R", "M", "M", "M", "M", "M"])

			mower = mowing_system.mowers[1] 
			expect(mower.x).to eql(3)
			expect(mower.y).to eql(0)
			expect(mower.direction).to eql("S")
			expect(mower.moves).to eql(["M", "M", "M", "M", "M", "R", "M", "R", "M", "M", "M", "M", "M"])

			mower = mowing_system.mowers[2] 
			expect(mower.x).to eql(5)
			expect(mower.y).to eql(0)
			expect(mower.direction).to eql("S")
			expect(mower.moves).to eql(["M", "M", "M", "M", "M", "R", "M", "R", "M", "M", "M", "M", "M"])
		end
	end
end

describe LawnMowing::ManualMowingSystem do 
	describe "reading file" do
		describe "when file is empty" do
			it "file should be found" do 
				file_name = LawnMowing::ManualMowingSystem::FILE_NAME
				expect(File.exist?(file_name)).to eql(true)
			end
			it "file is read" do 
				result = LawnMowing::MowingSystem.read_file 
				expect(result.class).to eql(Array)
				expect(result.size).to eql(5)
				expect(result[0]).to eql("5 5")
				expect(result[1]).to eql("1 2 N")
				expect(result[2]).to eql("LMLMLMLMM")
				expect(result[3]).to eql("3 3 E")
				expect(result[4]).to eql("MMRMMRMRRM")
				expect(result[5]).to eql(nil)
			end
		end

		describe "when file name is not empty" do
			it "manual file is correct" do 
				result = LawnMowing::MowingSystem.read_file(LawnMowing::ManualMowingSystem::FILE_NAME)
				expect(result.class).to eql(Array)
				expect(result.size).to eql(5)
				expect(result[0]).to eql("5 5")
				expect(result[1]).to eql("1 2 N")
				expect(result[2]).to eql("LMLMLMLMM")
				expect(result[3]).to eql("3 3 E")
				expect(result[4]).to eql("MMRMMRMRRM")
				expect(result[5]).to eql(nil)
			end
			it "file is not found" do 
				file_name = LawnMowing::ManualMowingSystem::FILE_NAME + "wrong name"
				result = LawnMowing::MowingSystem.read_file(file_name)
				expect(result.class).to eql(String)
				expect(result.include?("anual_mowing.txtwrong name doesn't exist.")).to eql(true)
			end
		end
	end

	describe "init using array" do 
		it "do" do 
			array_lines = ["5 5", "1 2 N", "LMRLMR", "1 2 N"]
			expect(LawnMowing::ManualMowingSystem.init(array_lines)).to eql("Not valid sequence.")

			array_lines = ["5 5", "1 2 N", "LMRLMRA"]
			expect(LawnMowing::ManualMowingSystem.init(array_lines)).to eql("Not valid sequence.")

			array_lines = ["5 5"]
			expect(LawnMowing::ManualMowingSystem.init(array_lines).class).to eql(LawnMowing::ManualMowingSystem)

			array_lines = ["5 5", "1 2 N", "LMRLMR"]
			expect(LawnMowing::ManualMowingSystem.init(array_lines).class).to eql(LawnMowing::ManualMowingSystem)
		end
	end

	describe "creating system" do 
		it "validate lines" do 
			array_lines = ["5 5", "1 2 N", "LMRLMR", "1 2 N"]
			expect(LawnMowing::ManualMowingSystem.is_valid?(array_lines)).to eq(false)

			array_lines = ["5 5", "1 2 N", "LMRLMR"]
			expect(LawnMowing::ManualMowingSystem.is_valid?(array_lines)).to eq(true)
			array_lines = ["55", "1 2 N", "LMRLMR"]
			expect(LawnMowing::ManualMowingSystem.is_valid?(array_lines)).to eq(false)
			array_lines = ["5 5a", "1 2 N", "LMRLMR"]
			expect(LawnMowing::ManualMowingSystem.is_valid?(array_lines)).to eq(false)
			array_lines = ["5a 5", "1 2 N", "LMRLMR"]
			expect(LawnMowing::ManualMowingSystem.is_valid?(array_lines)).to eq(false)
			array_lines = ["5 5 5", "1 2 N", "LMRLMR"]
			expect(LawnMowing::ManualMowingSystem.is_valid?(array_lines)).to eq(false)
			array_lines = ["55", "1 2 N", "LMRLMR"]
			expect(LawnMowing::ManualMowingSystem.is_valid?(array_lines)).to eq(false)

			array_lines = ["5 5", "1 2 N", "LMRLMR"]
			expect(LawnMowing::ManualMowingSystem.is_valid?(array_lines)).to eq(true)
			array_lines = ["5 5", "1 2 E", "LMRLMR"]
			expect(LawnMowing::ManualMowingSystem.is_valid?(array_lines)).to eq(true)
			array_lines = ["5 5", "1 2 W", "LMRLMR"]
			expect(LawnMowing::ManualMowingSystem.is_valid?(array_lines)).to eq(true)
			array_lines = ["5 5", "1 2 S", "LMRLMR"]
			expect(LawnMowing::ManualMowingSystem.is_valid?(array_lines)).to eq(true)
			array_lines = ["5 5", "12 N", "LMRLMR"]
			expect(LawnMowing::ManualMowingSystem.is_valid?(array_lines)).to eq(false)
			array_lines = ["5 5", "a1 2 N", "LMRLMR"]
			expect(LawnMowing::ManualMowingSystem.is_valid?(array_lines)).to eq(false)
			array_lines = ["5 5", "1 2a N", "LMRLMR"]
			expect(LawnMowing::ManualMowingSystem.is_valid?(array_lines)).to eq(false)
			array_lines = ["5 5", "1 2 A", "LMRLMR"]
			expect(LawnMowing::ManualMowingSystem.is_valid?(array_lines)).to eq(false)
			array_lines = ["5 5", "1 2 NA", "LMRLMR"]
			expect(LawnMowing::ManualMowingSystem.is_valid?(array_lines)).to eq(false)

			array_lines = ["5 5", "1 2 N", ""]
			expect(LawnMowing::ManualMowingSystem.is_valid?(array_lines)).to eq(true)
			array_lines = ["5 5", "1 2 N", "ALMRLMR"]
			expect(LawnMowing::ManualMowingSystem.is_valid?(array_lines)).to eq(false)
			array_lines = ["5 5", "1 2 N", "LMARLMR"]
			expect(LawnMowing::ManualMowingSystem.is_valid?(array_lines)).to eq(false)
			array_lines = ["5 5", "1 2 N", "LMRLMRA"]
			expect(LawnMowing::ManualMowingSystem.is_valid?(array_lines)).to eq(false)
		end

		before { @mowing_system = LawnMowing::MowingSystem.new(5, 5) }
		it "initialize" do
			expect(@mowing_system.lawn_x).to eql(5)
			expect(@mowing_system.lawn_y).to eql(5)
			expect(@mowing_system.mowers).to eql([])
		end

		it "set lawn dimensions" do
			@mowing_system.set_lawn_dimensions(10, 10)
			expect(@mowing_system.lawn_x).to eql(10)
			expect(@mowing_system.lawn_y).to eql(10)
		end

		it "add mower" do
			@mowing_system.add_mower(LawnMowing::ManualMower.new(1,2, "N", "LMLMLM"))
			mower = @mowing_system.mowers[0]
			expect(mower.index).to eql(0)
			expect(mower.x).to eql(1)
			expect(mower.y).to eql(2)
			expect(mower.direction).to eql("N")
			expect(mower.moves).to eql(["L", "M", "L", "M", "L", "M"])
		end

		it "add mower outside lawn" do
			@mowing_system.add_mower(LawnMowing::ManualMower.new(6,6, "N", "LMLMLM"))
			expect(@mowing_system.mowers.count).to eql(0)
		end

		it "getting positions" do 
			@mowing_system.add_mower(LawnMowing::ManualMower.new(2,4, "N", "LMLMLM"))
			@mowing_system.add_mower(LawnMowing::ManualMower.new(1,1, "N", "LMLMLM"))
			lawn_mowers_positions = @mowing_system.lawn_mowers_positions
			expect(lawn_mowers_positions).to eql([[5, 5], [2, 4, "N", "LMLMLM"], [1, 1, "N", "LMLMLM"]])
		end
	end

	describe "has possible moves" do

		before { 
			@mowing_system = LawnMowing::ManualMowingSystem.new(5, 5) 
		}

		it " can move" do 
			@mowing_system.add_mower(LawnMowing::ManualMower.new(1, 2, "N", "LMLMLM"))
			expect(@mowing_system.has_possible_moves).to eql(true)
		end

		it "can not move" do
			@mowing_system.add_mower(LawnMowing::ManualMower.new(1, 2, "N", "LMLMLM"))
			expect(@mowing_system.has_possible_moves).to eql(true)
			@mowing_system.mowers[0].number_tries = 10 
			expect(@mowing_system.has_possible_moves).to eql(false)
			@mowing_system.mowers[0].number_tries = 0 
			@mowing_system.mowers[0].index_movement = "LMLMLM".size
			expect(@mowing_system.has_possible_moves).to eql(false)
		end
	end

	describe "run system" do 
		it "show result 1" do
			array_lines = []
			array_lines << "5 5"
			array_lines << "1 2 N"
			array_lines << "LMLMLMLMM"
			array_lines << "3 3 E"
			array_lines << "MMRMMRMRRM"
			manualMowingSystem = LawnMowing::ManualMowingSystem.init(array_lines)
			manualMowingSystem.run_system
			expect(manualMowingSystem.mowers[0].x).to eql(1)
			expect(manualMowingSystem.mowers[0].y).to eql(3)
			expect(manualMowingSystem.mowers[0].direction).to eql("N") 
			expect(manualMowingSystem.mowers[1].x).to eql(5)
			expect(manualMowingSystem.mowers[1].y).to eql(1) 
			expect(manualMowingSystem.mowers[1].direction).to eql("E") 

	# 		# 1 3 N
	# 		# 5 1 E
			
		end

		it "show result 2" do
			array_lines = []
			array_lines << "5 5"
			array_lines << "0 0 N"
			array_lines << "MMMMMMMMMMMM"
			array_lines << "0 2 E"
			array_lines << "MMMMMMMMMMMM"
			manualMowingSystem = LawnMowing::ManualMowingSystem.init(array_lines)

			manualMowingSystem.run_system
			expect(manualMowingSystem.mowers[0].x).to eql(0)
			expect(manualMowingSystem.mowers[0].y).to eql(5)
			expect(manualMowingSystem.mowers[0].direction).to eql("N") 
			expect(manualMowingSystem.mowers[1].x).to eql(5)
			expect(manualMowingSystem.mowers[1].y).to eql(2) 
			expect(manualMowingSystem.mowers[1].direction).to eql("E") 

			# 0 5 N
			# 5 2 E
			
		end

		it "show result 2" do
			array_lines = []
			array_lines << "5 5"
			array_lines << "0 0 N"
			array_lines << "MMMMMMMMMMMM"
			array_lines << "0 5 S"
			array_lines << "M"
			manualMowingSystem = LawnMowing::ManualMowingSystem.init(array_lines)

			manualMowingSystem.run_system
			expect(manualMowingSystem.mowers[0].x).to eql(0)
			expect(manualMowingSystem.mowers[0].y).to eql(3)
			expect(manualMowingSystem.mowers[0].direction).to eql("N") 
			expect(manualMowingSystem.mowers[1].x).to eql(0)
			expect(manualMowingSystem.mowers[1].y).to eql(4) 
			expect(manualMowingSystem.mowers[1].direction).to eql("S") 
			# 0 5 N
			# 5 2 E
			
		end
	end
end


describe LawnMowing::AutomaticMower do 
	describe "creating and dealing with mower" do 
		it "initialize" do
			mower = LawnMowing::AutomaticMower.new(0)
			expect(mower.index).to eql(0)
			expect(mower.x).to eql(0)
			expect(mower.y).to eql(0)
			expect(mower.direction).to eql("N")
			expect(mower.moves).to eql([])
		end

		it "set moves" do 
			mower = LawnMowing::AutomaticMower.new(0)
			expect(mower.moves).to eql([])
			mower.add_move("M")
			expect(mower.moves).to eql(["M"])
			mower.add_move("M")
			expect(mower.moves).to eql(["M", "M"])
			mower.add_move("L")
			expect(mower.moves).to eql(["M", "M", "L"])
		end

		it "doing a movements" do
			mower = LawnMowing::AutomaticMower.new(0)
			expect(mower.x).to eql(0)
			expect(mower.y).to eql(0)
			mower.do_move([[5,5], [1,0], [1,0] ])
			expect(mower.x).to eql(0)
			expect(mower.y).to eql(1)
			expect(mower.direction).to eql("N")
			expect(mower.moves).to eql(["M"])

			mower.do_move([[5,5], [1,0], [1,0] ])
			expect(mower.x).to eql(0)
			expect(mower.y).to eql(2)
			expect(mower.direction).to eql("N")
			expect(mower.moves).to eql(["M", "M"])

			mower.do_move([[5,5], [1,0], [1,0] ])
			expect(mower.x).to eql(0)
			expect(mower.y).to eql(3)
			expect(mower.direction).to eql("N")
			expect(mower.moves).to eql(["M", "M", "M"])

			mower.do_move([[5,5], [1,0], [1,0] ])
			expect(mower.x).to eql(0)
			expect(mower.y).to eql(4)
			expect(mower.direction).to eql("N")
			expect(mower.moves).to eql(["M", "M", "M", "M"])

			mower.do_move([[5,5], [1,0], [1,0] ])
			expect(mower.x).to eql(0)
			expect(mower.y).to eql(5)
			expect(mower.direction).to eql("N")
			expect(mower.moves).to eql(["M", "M", "M", "M", "M"])

			mower.do_move([[5,5], [1,0], [1,0] ])
			expect(mower.x).to eql(1)
			expect(mower.y).to eql(5)
			expect(mower.direction).to eql("S")
			expect(mower.moves).to eql(["M", "M", "M", "M", "M", "R", "M", "R"])

			mower.do_move([[5,5], [1,0], [1,0] ])
			expect(mower.x).to eql(1)
			expect(mower.y).to eql(4)
			expect(mower.direction).to eql("S")
			expect(mower.moves).to eql(["M", "M", "M", "M", "M", "R", "M", "R", "M"])

		end

	end
end






describe LawnMowing::AutomaticMowingSystem do 

	describe "reading file" do
		describe "when file is empty" do
			it "file should be found" do 
				file_name = LawnMowing::AutomaticMowingSystem::FILE_NAME
				expect(File.exist?(file_name)).to eql(true)
			end
		end

		describe "when file name is not empty" do
			it "manual file is correct" do 
				result = LawnMowing::MowingSystem.read_file(LawnMowing::AutomaticMowingSystem::FILE_NAME)
				expect(result.class).to eql(Array)
				expect(result.size).to eql(1)
				expect(result[0]).to eql("5 5 3")
				expect(result[2]).to eql(nil)
			end
			it "file is not found" do 
				file_name = LawnMowing::AutomaticMowingSystem::FILE_NAME + "wrong name"
				result = LawnMowing::MowingSystem.read_file(file_name)
				expect(result.class).to eql(String)
				expect(result.include?("omatic_mowing.txtwrong name doesn't exist")).to eql(true)
			end
		end
	end

	describe "init using array" do 
		it "do" do 
			array_lines = ["5 5 3", "1 2 N" ]
			expect(LawnMowing::AutomaticMowingSystem.init(array_lines)).to eql("Not valid sequence.")

			array_lines = ["5 5 3"]
			automatic_mowing_system = LawnMowing::AutomaticMowingSystem.init(array_lines)
			expect(automatic_mowing_system.class).to eql(LawnMowing::AutomaticMowingSystem)
			expect(automatic_mowing_system.mowers.size).to eql(3)
			expect(automatic_mowing_system.lawn_x).to eql(5)
			expect(automatic_mowing_system.lawn_y).to eql(5)
		
			mower = automatic_mowing_system.mowers[0]
			expect(mower.index).to eql(0)
			expect(mower.x).to eql(0)
			expect(mower.y).to eql(0)
			expect(mower.direction).to eql("N")
			expect(mower.moves).to eql([])

			mower = automatic_mowing_system.mowers[1]
			expect(mower.index).to eql(1)
			expect(mower.x).to eql(2)
			expect(mower.y).to eql(0)
			expect(mower.direction).to eql("N")
			expect(mower.moves).to eql([])

			mower = automatic_mowing_system.mowers[2]
			expect(mower.index).to eql(2)
			expect(mower.x).to eql(4)
			expect(mower.y).to eql(0)
			expect(mower.direction).to eql("N")
			expect(mower.moves).to eql([])
		end
	end

	describe "has possible moves even lawn" do
		before { 
			@mowing_system = LawnMowing::AutomaticMowingSystem.new(3, 3) 
		}

		it "can move one" do 
			mower = LawnMowing::AutomaticMower.new(0)
			@mowing_system.add_mower(mower)
			expect(mower.index).to eql(0)
			expect(mower.x).to eql(0)
			expect(mower.y).to eql(0)
			expect(mower.direction).to eql("N")
			expect(mower.moves).to eql([])
			expect(@mowing_system.has_possible_moves).to eql(true)


			mower.x = 3
			mower.y = 3
			expect(@mowing_system.has_possible_moves).to eql(false)
		end

		it "move 2 mowers" do 
			mower_1 = LawnMowing::AutomaticMower.new(0)
			@mowing_system.add_mower(mower_1)
			expect(mower_1.index).to eql(0)
			expect(mower_1.x).to eql(0)
			expect(mower_1.y).to eql(0)
			expect(mower_1.direction).to eql("N")
			expect(mower_1.moves).to eql([])
			expect(@mowing_system.has_possible_moves).to eql(true)

			mower_2 = LawnMowing::AutomaticMower.new(2)
			@mowing_system.add_mower(mower_2)
			expect(mower_2.index).to eql(1)
			expect(mower_2.x).to eql(2)
			expect(mower_2.y).to eql(0)
			expect(mower_2.direction).to eql("N")
			expect(mower_2.moves).to eql([])
			expect(@mowing_system.has_possible_moves).to eql(true)

			mower_1.do_action(@mowing_system.lawn_mowers_positions)
			expect(mower_1.x).to eql(0)
			expect(mower_1.y).to eql(1)
			expect(mower_1.direction).to eql("N")
			expect(mower_1.moves).to eql(["M"])
			expect(@mowing_system.has_possible_moves).to eql(true)

			mower_2.do_action(@mowing_system.lawn_mowers_positions)
			expect(mower_2.x).to eql(2)
			expect(mower_2.y).to eql(1)
			expect(mower_2.direction).to eql("N")
			expect(mower_2.moves).to eql(["M"])
			expect(@mowing_system.has_possible_moves).to eql(true)

			mower_1.do_action(@mowing_system.lawn_mowers_positions)
			expect(mower_1.x).to eql(0)
			expect(mower_1.y).to eql(2)
			expect(mower_1.direction).to eql("N")
			expect(mower_1.moves).to eql(["M", "M"])
			expect(@mowing_system.has_possible_moves).to eql(true)

			mower_2.do_action(@mowing_system.lawn_mowers_positions)
			expect(mower_2.x).to eql(2)
			expect(mower_2.y).to eql(2)
			expect(mower_2.direction).to eql("N")
			expect(mower_2.moves).to eql(["M", "M"])
			expect(@mowing_system.has_possible_moves).to eql(true)

			mower_1.do_action(@mowing_system.lawn_mowers_positions)
			expect(mower_1.x).to eql(0)
			expect(mower_1.y).to eql(3)
			expect(mower_1.direction).to eql("N")
			expect(mower_1.moves).to eql(["M", "M", "M"])
			expect(@mowing_system.has_possible_moves).to eql(true)

			mower_2.do_action(@mowing_system.lawn_mowers_positions)
			expect(mower_2.x).to eql(2)
			expect(mower_2.y).to eql(3)
			expect(mower_2.direction).to eql("N")
			expect(mower_2.moves).to eql(["M", "M", "M"])
			expect(@mowing_system.has_possible_moves).to eql(true)

			mower_1.do_action(@mowing_system.lawn_mowers_positions)
			expect(mower_1.x).to eql(1)
			expect(mower_1.y).to eql(3)
			expect(mower_1.direction).to eql("S")
			expect(mower_1.moves).to eql(["M", "M", "M", "R", "M", "R"])
			expect(@mowing_system.has_possible_moves).to eql(true)

			mower_2.do_action(@mowing_system.lawn_mowers_positions)
			expect(mower_2.x).to eql(3)
			expect(mower_2.y).to eql(3)
			expect(mower_2.direction).to eql("S")
			expect(mower_2.moves).to eql(["M", "M", "M", "R", "M", "R"])
			expect(@mowing_system.has_possible_moves).to eql(true)

			mower_1.do_action(@mowing_system.lawn_mowers_positions)
			expect(mower_1.x).to eql(1)
			expect(mower_1.y).to eql(2)
			expect(mower_1.direction).to eql("S")
			expect(mower_1.moves).to eql(["M", "M", "M", "R", "M", "R", "M"])
			expect(@mowing_system.has_possible_moves).to eql(true)

			mower_2.do_action(@mowing_system.lawn_mowers_positions)
			expect(mower_2.x).to eql(3)
			expect(mower_2.y).to eql(2)
			expect(mower_2.direction).to eql("S")
			expect(mower_2.moves).to eql(["M", "M", "M", "R", "M", "R", "M"])
			expect(@mowing_system.has_possible_moves).to eql(true)

			mower_1.do_action(@mowing_system.lawn_mowers_positions)
			expect(mower_1.x).to eql(1)
			expect(mower_1.y).to eql(1)
			expect(mower_1.direction).to eql("S")
			expect(mower_1.moves).to eql(["M", "M", "M", "R", "M", "R", "M", "M"])
			expect(@mowing_system.has_possible_moves).to eql(true)

			mower_2.do_action(@mowing_system.lawn_mowers_positions)
			expect(mower_2.x).to eql(3)
			expect(mower_2.y).to eql(1)
			expect(mower_2.direction).to eql("S")
			expect(mower_2.moves).to eql(["M", "M", "M", "R", "M", "R", "M", "M"])
			expect(@mowing_system.has_possible_moves).to eql(true)

			mower_1.do_action(@mowing_system.lawn_mowers_positions)
			expect(mower_1.x).to eql(1)
			expect(mower_1.y).to eql(0)
			expect(mower_1.direction).to eql("S")
			expect(mower_1.moves).to eql(["M", "M", "M", "R", "M", "R", "M", "M", "M"])
			expect(@mowing_system.has_possible_moves).to eql(true)

			mower_2.do_action(@mowing_system.lawn_mowers_positions)
			expect(mower_2.x).to eql(3)
			expect(mower_2.y).to eql(0)
			expect(mower_2.direction).to eql("S")
			expect(mower_2.moves).to eql(["M", "M", "M", "R", "M", "R", "M", "M", "M"])

			expect(@mowing_system.has_possible_moves).to eql(false)

			puts ""
			@mowing_system.print_output
		end
	end

describe "has possible moves odd lawn" do
		before { 
			@mowing_system = LawnMowing::AutomaticMowingSystem.new(4, 2) 
		}

		it "can move one" do 
			mower = LawnMowing::AutomaticMower.new(0)
			@mowing_system.add_mower(mower)
			expect(mower.index).to eql(0)
			expect(mower.x).to eql(0)
			expect(mower.y).to eql(0)
			expect(mower.direction).to eql("N")
			expect(mower.moves).to eql([])
			expect(@mowing_system.has_possible_moves).to eql(true)


			mower.x = 3
			mower.y = 2
			expect(@mowing_system.has_possible_moves).to eql(true)

			mower.x = 4
			mower.y = 2
			expect(@mowing_system.has_possible_moves).to eql(false)

			mower.x = 4
			mower.y = 0
			mower.direction = "S"
			expect(@mowing_system.has_possible_moves).to eql(false)
		end

		it "move 2 mowers" do 
			mower_1 = LawnMowing::AutomaticMower.new(0)
			@mowing_system.add_mower(mower_1)
			expect(mower_1.index).to eql(0)
			expect(mower_1.x).to eql(0)
			expect(mower_1.y).to eql(0)
			expect(mower_1.direction).to eql("N")
			expect(mower_1.moves).to eql([])
			expect(@mowing_system.has_possible_moves).to eql(true)

			mower_2 = LawnMowing::AutomaticMower.new(2)
			@mowing_system.add_mower(mower_2)
			expect(mower_2.index).to eql(1)
			expect(mower_2.x).to eql(2)
			expect(mower_2.y).to eql(0)
			expect(mower_2.direction).to eql("N")
			expect(mower_2.moves).to eql([])
			expect(@mowing_system.has_possible_moves).to eql(true)

			mower_1.do_action(@mowing_system.lawn_mowers_positions)
			expect(mower_1.x).to eql(0)
			expect(mower_1.y).to eql(1)
			expect(mower_1.direction).to eql("N")
			expect(mower_1.moves).to eql(["M"])
			expect(@mowing_system.has_possible_moves).to eql(true)

			mower_2.do_action(@mowing_system.lawn_mowers_positions)
			expect(mower_2.x).to eql(2)
			expect(mower_2.y).to eql(1)
			expect(mower_2.direction).to eql("N")
			expect(mower_2.moves).to eql(["M"])
			expect(@mowing_system.has_possible_moves).to eql(true)

			mower_1.do_action(@mowing_system.lawn_mowers_positions)
			expect(mower_1.x).to eql(0)
			expect(mower_1.y).to eql(2)
			expect(mower_1.direction).to eql("N")
			expect(mower_1.moves).to eql(["M", "M"])
			expect(@mowing_system.has_possible_moves).to eql(true)

			mower_2.do_action(@mowing_system.lawn_mowers_positions)
			expect(mower_2.x).to eql(2)
			expect(mower_2.y).to eql(2)
			expect(mower_2.direction).to eql("N")
			expect(mower_2.moves).to eql(["M", "M"])
			expect(@mowing_system.has_possible_moves).to eql(true)

			mower_1.do_action(@mowing_system.lawn_mowers_positions)
			expect(mower_1.x).to eql(1)
			expect(mower_1.y).to eql(2)
			expect(mower_1.direction).to eql("S")
			expect(mower_1.moves).to eql(["M", "M", "R", "M", "R"])
			expect(@mowing_system.has_possible_moves).to eql(true)

			mower_2.do_action(@mowing_system.lawn_mowers_positions)
			expect(mower_2.x).to eql(3)
			expect(mower_2.y).to eql(2)
			expect(mower_2.direction).to eql("S")
			expect(mower_2.moves).to eql(["M", "M", "R", "M", "R"])
			expect(@mowing_system.has_possible_moves).to eql(true)

			mower_1.do_action(@mowing_system.lawn_mowers_positions)
			expect(mower_1.x).to eql(1)
			expect(mower_1.y).to eql(1)
			expect(mower_1.direction).to eql("S")
			expect(mower_1.moves).to eql(["M", "M", "R", "M", "R", "M"])
			expect(@mowing_system.has_possible_moves).to eql(true)

			mower_2.do_action(@mowing_system.lawn_mowers_positions)
			expect(mower_2.x).to eql(3)
			expect(mower_2.y).to eql(1)
			expect(mower_2.direction).to eql("S")
			expect(mower_2.moves).to eql(["M", "M", "R", "M", "R", "M"])
			expect(@mowing_system.has_possible_moves).to eql(true)

			mower_1.do_action(@mowing_system.lawn_mowers_positions)
			expect(mower_1.x).to eql(1)
			expect(mower_1.y).to eql(0)
			expect(mower_1.direction).to eql("S")
			expect(mower_1.moves).to eql(["M", "M", "R", "M", "R", "M", "M"])
			expect(mower_1.can_move?(@mowing_system.lawn_mowers_positions)).to eql(false)
			expect(@mowing_system.has_possible_moves).to eql(true)

			mower_2.do_action(@mowing_system.lawn_mowers_positions)
			expect(mower_2.x).to eql(3)
			expect(mower_2.y).to eql(0)
			expect(mower_2.direction).to eql("S")
			expect(mower_2.moves).to eql(["M", "M", "R", "M", "R", "M", "M"])
			expect(mower_2.can_move?(@mowing_system.lawn_mowers_positions)).to eql(true)
			expect(@mowing_system.has_possible_moves).to eql(true)

			mower_2.do_action(@mowing_system.lawn_mowers_positions)
			expect(mower_2.x).to eql(4)
			expect(mower_2.y).to eql(0)
			expect(mower_2.direction).to eql("N")
			expect(mower_2.moves).to eql(["M", "M", "R", "M", "R", "M", "M", "L", "M", "L"])
			expect(@mowing_system.has_possible_moves).to eql(true)

			mower_2.do_action(@mowing_system.lawn_mowers_positions)
			expect(mower_2.x).to eql(4)
			expect(mower_2.y).to eql(1)
			expect(mower_2.direction).to eql("N")
			expect(mower_2.moves).to eql(["M", "M", "R", "M", "R", "M", "M", "L", "M", "L", "M"])
			expect(@mowing_system.has_possible_moves).to eql(true)

			mower_2.do_action(@mowing_system.lawn_mowers_positions)
			expect(mower_2.x).to eql(4)
			expect(mower_2.y).to eql(2)
			expect(mower_2.direction).to eql("N")
			expect(mower_2.moves).to eql(["M", "M", "R", "M", "R", "M", "M", "L", "M", "L", "M", "M"])
			expect(mower_2.can_move?(@mowing_system.lawn_mowers_positions)).to eql(false)
			expect(@mowing_system.has_possible_moves).to eql(false)

			puts ""
			@mowing_system.print_output
		end
	end

	describe "run system" do 

			it "show result 1" do
				array_lines = []
				array_lines << "5 5 3"
				mowing_system = LawnMowing::AutomaticMowingSystem.init(array_lines)

puts "\n\n"
				mowing_system.run_system
				mowing_system.print_input
				puts ""
				mowing_system.print_output
				mower = mowing_system.mowers[0]
				expect(mower.x).to eql(1)
				expect(mower.y).to eql(0)
				expect(mower.initial_x).to eql(0)
				expect(mower.direction).to eql("S")
				expect(mower.moves).to eql(["M","M","M","M","M","R","M","R","M","M","M","M","M"])
				mower = mowing_system.mowers[1]
				expect(mower.x).to eql(3)
				expect(mower.y).to eql(0)
				expect(mower.initial_x).to eql(2)
				expect(mower.direction).to eql("S")
				expect(mower.moves).to eql(["M","M","M","M","M","R","M","R","M","M","M","M","M"])
				mower = mowing_system.mowers[2]
				expect(mower.x).to eql(5)
				expect(mower.y).to eql(0)
				expect(mower.initial_x).to eql(4)
				expect(mower.direction).to eql("S")
				expect(mower.moves).to eql(["M","M","M","M","M","R","M","R","M","M","M","M","M"])

				# puts ""
				# manualMowingSystem.print_output
				# expect(manualMowingSystem.mowers[0].x).to eql(1)
				# expect(manualMowingSystem.mowers[0].y).to eql(3)
				# expect(manualMowingSystem.mowers[0].direction).to eql("N") 
				# expect(manualMowingSystem.mowers[1].x).to eql(5)
				# expect(manualMowingSystem.mowers[1].y).to eql(1) 
				# expect(manualMowingSystem.mowers[1].direction).to eql("E") 

# 5 5 3

# 0 0 N
# MMMMMRMRMMMMM
# 2 0 N
# MMMMMRMRMMMMM
# 4 0 N
# MMMMMRMRMMMMM
				
			end

			it "show result 2" do
				array_lines = []
				array_lines << "6 6 3"
				mowing_system = LawnMowing::AutomaticMowingSystem.init(array_lines)

				mowing_system.run_system

				mower = mowing_system.mowers[0]
				expect(mower.x).to eql(1)
				expect(mower.y).to eql(0)
				expect(mower.initial_x).to eql(0)
				expect(mower.direction).to eql("S")
				expect(mower.moves).to eql(["M", "M", "M", "M", "M", "M", "R", "M", "R", "M", "M", "M", "M", "M", "M"])
				mower = mowing_system.mowers[1]
				expect(mower.x).to eql(3)
				expect(mower.y).to eql(0)
				expect(mower.initial_x).to eql(2)
				expect(mower.direction).to eql("S")
				expect(mower.moves).to eql(["M", "M", "M", "M", "M", "M", "R", "M", "R", "M", "M", "M", "M", "M", "M"])
				mower = mowing_system.mowers[2]
				expect(mower.x).to eql(6)
				expect(mower.y).to eql(6)
				expect(mower.initial_x).to eql(4)
				expect(mower.direction).to eql("N")
				expect(mower.moves).to eql(["M", "M", "M", "M", "M", "M", "R", "M", "R", "M", "M", "M", "M", "M", "M", "L", "M", "L", "M", "M", "M", "M", "M", "M"])

# mowing_system.print_input
# mowing_system.print_output
# 6 6 3
# 0 0 N
# MMMMMMRMRMMMMMM
# 2 0 N
# MMMMMMRMRMMMMMM
# 4 0 N
# MMMMMMRMRMMMMMMLMLMMMMMM
				
			end
		end

end
