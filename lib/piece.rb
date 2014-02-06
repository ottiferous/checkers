
class Piece

  def initialize(color, board, position)
    @color, @position = color, position

    board.app_piece(self, pos)
  end
end
