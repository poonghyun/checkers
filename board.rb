require './piece.rb'

class Board
	attr_accessor :grid, :active_player, :size

	def initialize(size = 8)
		@size = size
		@grid = Array.new(size) { Array.new(size) }
		add_starting_pieces
		# self.grid[6][3] = Piece.new(self, [6, 3], :black)
		# self.grid[1][2] = Piece.new(self, [1, 2], :red)
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

	def flip_active_player
		if active_player == :black
			self.active_player = :red
		else
			self.active_player = :black
		end
	end

	# returns all pieces of a specified color in an array
	def find_color(color)
		grid.flatten.compact.select { |piece| piece.color == color }
	end

end