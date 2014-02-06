
class CheckersBoard

  def initialize(pre_populate = true)
    @rows = Array.new(8) { Array.new(8) }
    fill_in if pre_populate
  end

  # replace with a render method later ( suprresses board info )
  def inspect
  
    nil
  end
  
  def add_piece(piece, position)
    @rows[position[0]][position[1]] = piece.class.new(piece.color, piece.board, position)
  end
  
  def fill_in

    # place back and front for :white
    [0, 1].each do |row|
      (0..7).each do |x|
        @rows[row][x] = Piece.new(:white, self, [row, x]) if x.odd?
      end
    end
    # place middle row for :white
    (0..6).each do |x|
      @rows[2][x] = Piece.new(:white, self, [1, x]) if x.even?
    end
    
    # place back and front for :red
    [5, 7].each do |row|
      (0..7).each do |x|
        @rows[row][x] = Piece.new(:red, self, [row, x]) if x.even?
      end
    end
    # place middle row for :red
    (0..6).each do |x|
      @rows[6][x] = Piece.new(:red, self, [6, x]) if x.odd?
    end
      
  end
  
  def [](pos)
    x, y = pos
    @rows[x][y]
  end
  
  def empty?(position)
    self[position].nil? ? true : false
  end
  
  def occupied?(position)
    self[position].nil? ? false : true
  end
  
  def color_at(position)
    self[position].color
  end
  
end
