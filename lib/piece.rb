
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
      return true
    end
    
    false
  end
    
  def valid_slides
    vectors = slide_vectors
    moves = []
    vectors.each do |vec|
      p vec
      test = smush(vec, self.position)
      moves << test if @board.empty?(test)
    end
    moves
  end

  def perform_jump(end_pos)
    start_pos = self.position
    if valid_jumps(start_pos, end_pos).include? end_pos
      move_piece!(end_pos)
      return true
    end
    
    false
  end
  
  def valid_jumps(from_pos)
    vectors = jump_vectors
    moves = []
    vectors.each do |vec|
      test = smush(vec, from_pos)
      hop_over_spot = test.map { |_| _ / 2 }
      
      # end location is empty and interim spot has a piece of opposite color
      if @board.empty?(test) && @board.color_at(hop_over_spot) != @color
        moves << test
      end
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
    @color == :white ? [[1,-1], [1,1]] : [[-1,-1], [-1,1]]
  end
  
  def jump_vectors
    @coclor == :white ? [[2,-2], [2,2]] : [[-2,-2], [-2,2]]
  end
  
  def smush(x, y)
    new_x = x[0] + y[0]
    new_y = x[1] + y[1]
    [new_x, new_y]
  end
end
