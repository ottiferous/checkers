# -*- coding: utf-8 -*-
class Board

  def initialize(pre_populate = true)
    @rows = Array.new(8) { Array.new(8) }
    fill_in if pre_populate
  end

  # replace with a render method later
  def inspect
    render_top_rule
    @rows.each_with_index do |array_rows, index|
      print "#{index} "
      array_rows.each do |cell|
        print (cell.nil? ? " " : cell.symbol )
      end
      print "\n"
    end
      
    nil
  end
  
  def render_top_rule
    print "  "
    (0..7).each { |num| print "#{num}" }
    print "\n"
  end
  
  def draw
    self.inspect
  end
    
  def add_piece(piece, position)
    x, y = position
    @rows[x][y] = piece.class.new(piece.color, piece.board, position)
  end

  def remove_piece_at(position)
    x,y = position
    piece = @rows[x][y]
    piece.board = nil
    piece.position = nil
    piece = nil
    @rows[x][y] = nil
  end
  
  def fill_in

    # place back and front for :white
    [0, 2].each do |row|
      (0..7).each do |x|
        @rows[row][x] = Piece.new(:white, self, [row, x]) if x.odd?
      end
    end
    # place middle row for :white
    (0..6).each do |x|
      @rows[1][x] = Piece.new(:white, self, [1, x]) if x.even?
    end
    
    # place back and front for :red
    [5, 7].each do |row|
      (0..7).each do |x|
        @rows[row][x] = Piece.new(:red, self, [row, x]) if x.even?
      end
    end
    # place middle row for :red
    (0..7).each do |x|
      @rows[6][x] = Piece.new(:red, self, [6, x]) if x.odd?
    end
      
  end
  
  def dup
    duped_board = Board.new(false)
    
    (0...8).each do |row|
      (0...8).each do |col|
        unless self[[col,row]].nil?
          piece = self[[col,row]]
          duped_board[[col,row]] = self[[col,row]].class.new(
            piece.color,
            duped_board,
            piece.position.dup,
            piece.symbol,
            piece.king
          )
        end
      end
    end
    
    duped_board
  end
  
  def [](pos)
    x, y = pos
    @rows[x][y]
  end
  
  def []=(pos, piece)
    x, y = pos
    @rows[x][y] = piece
  end
  
  def valid_move?(position)
    position.any? { |_| _ < 8 } ? true : false
  end
  
  def empty?(position)
    return false unless position.all? { |_| _.between?(0,7) }
    self[position].nil? ? true : false
  end
  
  def occupied?(position)
    self[position].nil? ? false : true
  end
  
  def color_at(position)
    self[position].nil? ? nil : self[position].color
  end
  
  def all_of(color)
    @rows.flatten.compact.select{ |piece| piece.color == color }
  end
    
end
