class InvalidMoveError < StandardError
end

class EmptySquareError < InvalidMoveError
end

class NachoPieceError < InvalidMoveError
end