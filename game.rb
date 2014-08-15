require './board.rb'

class Game
	attr_accessor :board

	def initialize
		@board = Board.new
		@board.add_starting_pieces
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
			begin
				puts "Which piece (i.e. '0,1')?"
				j, i = gets.chomp.split(",").map { |coord| coord.to_i }
				piece = board[[i, j]]
				raise EmptySquareError if piece.nil?
				raise NachoPieceError unless piece.color == board.active_player
			rescue EmptySquareError
				puts "There's no piece there."
				retry
			rescue NachoPieceError
				puts "That's not your piece."
				retry
			rescue TypeError
				puts "Invalid input."
				retry
			end

			begin
				move_sequence = get_move_sequence
			rescue NoMoveProvidedError
				puts "You didn't provide any moves."
				retry
			end

			begin
		 		moved = perform_moves(piece, move_sequence)
		 	rescue ForcedJumpError
		 		puts "You need to continue to jump."
		 	end

			puts "Not valid." unless moved
		end
	end

	def perform_moves(piece, move_sequence)
		if piece.valid_move_sequence?(move_sequence)
			piece.perform_moves!(move_sequence)
		else
			false
		end
	end

	def get_move_sequence
		moves = []
		while true
			puts "Next move? (just hit enter to end move sequence)"
			input = gets.chomp
			break if input == ""
			j, i = input.split(",").map { |coord| coord.to_i }
			moves << [i, j]
		end
		raise NoMoveProvidedError if moves.empty?
		moves
	end

	def render
		board.grid.each_with_index do |row, row_index|
			print " #{row_index} "
			row.each_with_index do |square, col_index|
				background = :white
				if (row_index + col_index).even?
					background = :light_blue
				end
				if square.nil?
					print "   ".colorize( :background => background )
				else
					print square.draw.colorize( :background => background )
				end
			end
			puts
		end
		puts "    0  1  2  3  4  5  6  7 "
	end

end

Game.new.run