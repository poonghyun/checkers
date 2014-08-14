require './board.rb'

class Game
	attr_accessor :board

	def initialize
		@board = Board.new(8)
	end

	def run
		puts "Welcome to Checkers!"
		while board.winner.nil?
			render
			move
			board.flip_active_player
		end
		render
		puts "#{board.winner.to_s.capitalize} wins!"
	end

	def move
		puts "#{board.active_player.to_s.capitalize}'s turn."
		moved = false
		until moved
			puts "Which piece (i.e. '0,1')?"
			j1, i1 = gets.chomp.split(",").map { |coord| coord.to_i }

			puts "Where are you going?"
			j2, i2 = gets.chomp.split(",").map { |coord| coord.to_i }

			piece = board[[i1, j1]]

			if !piece.nil? && piece.color == board.active_player
				moved = piece.perform_slide([i2, j2]) || piece.perform_jump([i2, j2])
			end

			puts "That was not a valid move." unless moved
		end
	end

	def render
		board.grid.each_with_index do |row, row_index|
			print " #{row_index} "
			row.each do |square|
				square.nil? ? (print "[ ]") : square.draw
			end
			puts
		end
		puts "    0  1  2  3  4  5  6  7 "
	end

end

Game.new.run
# game.render
# puts

# game.board[[2, 1]].perform_slide([3,2])
# game.render
# puts

# game.board[[3, 2]].perform_slide([4,3])
# game.render
# puts

# game.board[[5, 2]].perform_jump([3,4])
# game.render
# puts