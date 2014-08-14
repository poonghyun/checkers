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
		end

	end

	def render
		board.grid.each do |row|
			row.each do |square|
				square.nil? ? (print "[ ]") : square.draw
			end
			puts
		end
	end

end

Game.new.render