require './piece.rb'

class Board
	attr_accessor :grid, :active_player, :size

	def initialize(active_player = :red)
		@size = 8
		@grid = Array.new(size) { Array.new(size) }
		@active_player = active_player

		# @grid[1][2] = Piece.new(self, [1, 2], :black)
		# @grid[3][2] = Piece.new(self, [3, 2], :black)
		# @grid[5][2] = Piece.new(self, [5, 2], :black)
		# @grid[6][3] = Piece.new(self, [6, 3], :red)
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

	def clone
		board_clone = self.class.new(self.active_player)
		pieces = grid.flatten.compact
		pieces.each do |piece|
			board_clone[piece.position]= piece.clone(board_clone)
		end
		board_clone
	end

end