class Piece
	attr_accessor :board, :position, :color

	def initialize(board, position, color)
		@board = board
		@position = position
		@color = color
	end

	def perform_slide

	end

	def perform_jump

	end

	def draw
		print "[#{color.to_s[0]}]"
	end

end