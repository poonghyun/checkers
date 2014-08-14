require './exceptions.rb'

VECTORS = [[1, 1], [1, -1], [-1, 1], [-1, -1]]

class Piece
	attr_accessor :board, :position, :color

	def initialize(board, position, color)
		@board = board
		@position = position
		@color = color
		@is_king = false
	end

	def is_king?
		@is_king
	end

	def is_king=(val)
		@is_king = val
	end

	def perform_slide(destination)
		valid_slides = []
		move_diffs.each do |diff|
			valid_slides << [position.first + diff.first, position.last + diff.last]
		end
		# at this point we have two positions

		valid_slides.select! do |move|
			on_board?(move) && board[move].nil?
		end
		# all pruned

		if valid_slides.include?(destination)
			move_piece(destination)
			true
		else
			false
		end
	end

	def perform_jump(destination)
		valid_jumps = []
		move_diffs.each do |diff|
			valid_jumps << [position.first + (diff.first * 2), position.last + (diff.last * 2)]
		end

		valid_jumps.select! do |move|
			on_board?(move) && enemy_between?(move) && board[move].nil?
		end

		if valid_jumps.include?(destination)
			move_piece(destination)
			true
		else
			false
		end
	end

	def move_piece(destination)
		board[position] = nil
		board[destination] = self
		self.position = destination
	end

	# returns true if there is there is an enemy in the intermediary square
	def enemy_between?(destination)
		
	end

	# returns the differentials a piece can move in
	def move_diffs
		if is_king?
			VECTORS
		elsif color == :black
			VECTORS[0..1]
		else
			VECTORS[2..3]
		end
	end

	def has_enemy?(position)
		!board[position].nil? && board[position].color != self.color
	end

	def has_ally?(position)
		!board[position].nil? && board[position].color == self.color
	end

	def opposite(color)
		(color == :black) ? :red : :black
	end

	def on_board?(position)
		row = position.first
		col = position.last
		(0...board.size).cover?(row) && (0...board.size).cover?(col)
	end

	def draw
		print "[#{color.to_s[0]}]"
	end

end