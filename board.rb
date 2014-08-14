require './piece.rb'

class Board
	attr_accessor :grid, :active_player, :size

	def initialize(size = 8)
		@size = size
		@grid = Array.new(size) { Array.new(size) }
		add_starting_pieces
		@active_player = :red
	end

	def [](pos)
		i, j = pos
		@grid[i][j]
	end

	def []=(pos, piece)
		i, j = pos
		@grid[i][j] = piece
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
		return :red if find_color(:black).empty?
		return :black if find_color(:red).empty?
		nil
	end

	# returns all pieces of a specified color in an array
	def find_color(color)
		pieces = []
		grid.each do |row|
			row.each do |square|
				next if square.nil?
				pieces << square if square.color == color
			end
		end
		pieces
	end

end