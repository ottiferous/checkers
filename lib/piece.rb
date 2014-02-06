
class Piece

  attr_reader :color, :board, :position
  def initialize(color, board, position)
    @color, @position = color, position
    @board = board
  end

  def perform_slide(end_pos)
    start_pos = self.position
    if valid_slides(start_pos, end_pos).include? end_pos
      move_piece!(end_pos)
    end
  end
    
  def valid_slides(from_pos)
    vectors = slide_vectors
    moves = []
    vectors.each do |vec|
      test = smush(vec, from_pos)
      moves << test if @board.empty?(test)
    end
    moves
  end
  
  # Already checked to see if its a valid move - now we do it.
  def move_piece!(end_pos)
    @board[end_pos] = self
    @board[self.position] = nil
    self.position = end_pos
  end
  
  private
  
  # 'white' moves 'down' the array if drawn
  def slide_vectors
    @color == :white ? [[-1,1], [1,1]] : [[-1,-1], [1,-1]]
  end
  
  def jump_vectors
    @coclor == :white ? [[-2,2], [2,2]] : [[-2,-2], [2,-2]]
  end
  
  def smush(x, y)
    new_x = x[0] + y[0]
    new_y = x[1] + y[1]
    [new_x, new_y]
  end
end
