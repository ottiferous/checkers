# -*- coding: utf-8 -*-

class InvalidMoveError < ArgumentError
end

class Piece

  attr_accessor :color, :board, :position, :symbol, :king
  def initialize(color, board, position, symbol=nil, king=false)
    @color, @position = color, position
    @board = board
    @symbol = (color == :white ? "\u25CB" : "\u25CF")
    @king = king
  end

  def perform_slide(end_pos)
    start_pos = self.position
    if valid_slides.include? end_pos
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
    if valid_jumps.include? end_pos
      start_pos = self.position
      
      mid_y = start_pos[0] + (start_pos[0] < end_pos[0] ? 1 : -1)
      mid_x = start_pos[1] + (start_pos[1] < end_pos[1] ? 1 : -1)
      
      mid = [mid_y, mid_x]
      move_piece!(end_pos)
      @board.remove_piece_at(mid)
      
      return true
    end
    
    false
  end

    
  def valid_jumps
    vectors = jump_vectors
    moves = []
    vectors.each do |vec|

      test = smush(vec, self.position)
      hop_over_spot = smush((vec.map { |_| _ / 2 }), self.position)
      
      # end location is empty and interim spot has a piece of opposite color
      
      spot_color = @board.color_at(hop_over_spot)
      spot_color = (spot_color.nil? ? false : spot_color)
      if @board.empty?(test) && spot_color != false
        moves << test
      end
    end
    
    moves
  end
  
  def valid_sequence?(move_array)
    test_board = self.board.dup
    shadow = test_board[self.position]
    begin
      shadow.perform_moves!(move_array)
    rescue InvalidMoveError => error
      puts error.message
      return false
    else
      return true
    end
  end
  
  def perform_moves(move_array)
    if valid_sequence?(move_array)
      perform_moves!(move_array)
      true
    else
      false
    end
  end

  def perform_moves!(move_array)
    
    active_piece = self
    move_array.each do |move|
      
      if self.valid_slides.include? move
        self.perform_slide(move)
        active_piece = @board[move]
      elsif self.valid_jumps.include? move
        self.perform_jump(move)
        active_piece = @board
      else
        raise "An Invalid move was issued | #{move}"
      end
    end

    true
  end
  
  # Already checked to see if its a valid move - now we do it.
  def move_piece!(end_pos)
    @board[end_pos] = self
    @board[self.position] = nil
    @position = end_pos
  end
  
  private
  
  # 'white' moves 'down' the array if drawn
  def slide_vectors
    if @king == false
      return (@color == :white ? [[1,-1], [1,1]] : [[-1,-1], [-1,1]])
    else
      return [[1,-1], [1,1], [-1,-1], [-1,1]]
    end
  end
  
  def jump_vectors
    if @king == false
      return (@color == :white ? [[2,-2], [2,2]] : [[-2,-2], [-2,2]])
    else
      return [[2,-2], [2,2], [-2,-2], [-2,2]]
    end
  end
  
  def smush(x, y)
    new_x = x[0] + y[0]
    new_y = x[1] + y[1]
    [new_x, new_y]
  end
end
