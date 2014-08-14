require './king.rb'

class Board
	attr_accessor :grid, :active_player

	def initialize(size = 8)
		@grid = Array.new(size) { Array.new(size) }
		add_starting_pieces
		@active_player = :red
	end

	def add_starting_pieces
		grid.each_with_index do |row, row_index|
			row.each_index do |col_index|
				next if row_index > 2 && row_index < 5 # hardcoded for now
				next if (row_index + col_index).even?
				color = (row_index <= 2) ? :black : :red
				self.grid[row_index][col_index] = Piece.new(self, [row_index, col_index], color)
			end
		end
	end

	# returns the winner, or nil if there is none
	def winner

	end

	# returns all pieces of a specified color in an array
	def find_color(color)

	end

end