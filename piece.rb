require './exceptions.rb'

VECTORS = [[1, 1], [1, -1], [-1, 1], [-1, -1]]

class Piece
	attr_accessor :board, :position, :color

	def initialize(board, position, color, is_king = false)
		@board = board
		@position = position
		@color = color
		@is_king = is_king
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
		# at this point we have two or four positions

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
		if next_jumps.include?(destination)
			remove_jumped_piece(destination)
			move_piece(destination)
			true
		else
			false
		end
	end

	# returns possible jump locations for a piece
	def next_jumps
		valid_jumps = []
		move_diffs.each do |diff|
			valid_jumps << [position.first + (diff.first * 2), position.last + (diff.last * 2)]
		end

		valid_jumps.select! do |move|
			on_board?(move) && enemy_between?(move) && board[move].nil?
		end
	end

	def move_piece(destination)
		board[position] = nil
		board[destination] = self
		self.position = destination
		self.is_king = true if destination.first % 7 == 0 # hardcode for now
	end

	def remove_jumped_piece(destination)
		middle_row = (destination.first + position.first) / 2
		middle_col = (destination.last + position.last) / 2
		board[[middle_row, middle_col]] = nil
	end

	# returns true if there is there is an enemy in the intermediary square
	def enemy_between?(destination)
		middle_row = (destination.first + position.first) / 2
		middle_col = (destination.last + position.last) / 2
		has_enemy?([middle_row, middle_col])
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

	def perform_moves!(move_sequence)
		if move_sequence.length == 1
			perform_slide(move_sequence.first) || perform_jump(move_sequence.first)
		else
			move_sequence.all? { |move| perform_jump(move) }
		end
	end

	def valid_move_sequence?(move_sequence)
		piece_clone = board.clone[position]
		valid = piece_clone.perform_moves!(move_sequence)
		if valid
			raise ForcedJumpError unless piece_clone.next_jumps.empty?
		end
		valid
	end

	def has_enemy?(position)
		!board[position].nil? && board[position].color != self.color
	end

	def has_ally?(position)
		!board[position].nil? && board[position].color == self.color
	end

	def on_board?(position)
		row = position.first
		col = position.last
		(0...board.size).cover?(row) && (0...board.size).cover?(col)
	end

	def draw
		character = (is_king?) ? color.to_s[0].upcase : color.to_s[0]
		print "[#{character}]"
	end

	def clone(board)
		self.class.new(board, position.dup, color, is_king?)
	end
end