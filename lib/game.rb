require './piece.rb'
require './board.rb'

class OpponentPiece < ArgumentError; end
class WrongHumanInput < ArgumentError; end
class TargetOccupied < ArgumentError; end

class Game

  def initialize
    @board = Board.new
    @players = []
  end
  
  def play
    @players << Player.new(:white)
    @players << Player.new(:red)
    finished = false
    @board.draw

    until finished
      @players.each do |current_player|
        puts "#{current_player.name} (#{current_player.color})"
        begin 
          move = current_player.get_move
          start_pos = move.shift
          raise OpponentPiece if @board.color_at(start_pos) != current_player.color          
          @board[start_pos].perform_moves(move)
        rescue OpponentPiece
          puts "That's not your piece."
          retry
        rescue TargetOccupied
          puts "You can't move to there."
          retry
        end
        @board.draw
      end
      finished = self.game_over?(current_player.color)
    end
    puts "Game Over!"
    
  end
  
  def game_over?(color)
    @board.all_of(color).each do |piece|
      break if piece.has_moves?
    
      true
    end
  
  end
end

class Player

  attr_reader :color
  attr_accessor :name
  def initialize(color, name = "Player")
    @color = color
    @name = name + rand(100).to_s
  end
  
  def get_move
    print "Your move: "
    regex = /^(\d),(\d).*(\d),(\d)\s*$/
    
    begin
      coordinates = gets.chomp.match(regex).to_a
      coordinates.shift
      coordinates.map!(&:to_i)
      raise WrongHumanInput if coordinates.any? { |num| num > 8 || num < 0 }
    rescue WrongHumanInput
      puts "Did you make a typo?\n> "
      retry
    end
    start_x, start_y, end_x, end_y = coordinates
    [[start_x, start_y], [end_x, end_y]]
  end

end

if __FILE__ == $PROGRAM_NAME
  
  g = Game.new
  g.play
  
end